-- Ion3 script for boosting the CPU and I/O scheduling priority of the foreground application (i.e. the one that has focus in the window manager) on Linux.

-- NOTE: Two major limitations: (1) it requires superuser privileges to shift process niceness around willy-nilly (ionice is OK, however), and (2) it only affects the process that implements the actual X client, e.g. a terminal process running inside an xterm won't get any boost, only the xterm.  Still, ensuring that the terminal itself is responsive is probably still useful.  And, similarly, programs that run as multiple processes (e.g. firefox, vmware) will only have the process attached to the X window boosted/cut.  However, it might be possible to boost the entire process subtree.  (Also, I wonder what the various firefox-bin process actually do...)
 
-- NOTE: this script uses the "sudo" command in order to change the priorities using renice and ionice, so the window manager must be run by someone who has suitable permissions, e.g. NOPASSWD specified in /etc/sudoers.  If you don't, you'll get a password prompt in whatever terminal you launched Ion in, which may well be inacessible, and the window manager will effectively hang.  You can recover by killing the sudo process.
-- NOTE: not all X clients advertise properties such as their PID properly.  Some have a strange process structure, some lie, some simply don't tell.  It would be good to handle these cases more gracefully, somehow.

-- TODO: figure out why GVim's reported PIDs are wrong (and work around, if possible).
-- TODO: store the activated process's original niceness and restore it again on deactivation.
-- TODO: have the active workspace name/window frame title/command name/process ID/whatever appear in the statusbar (see e.g. Emanuele Giaquinta's statusbar_fname.lua)
-- TODO: suppress output from renice, ionice in Ion's main log stream.
-- TODO: ensure the screensaver doesn't get a boost.  That would be pointless.
-- TODO: check out Linux capabilities, e.g. CAP_SYS_NICE (man capabilities); it might be possible to avoid the use of sudo.  See http://www.linuxjournal.com/node/5737/print


-- To use, copy this script to ~/.ion3/ and add the following to your main ion configuration (e.g. ~/.ion3/cfg_ion.lua):
-- dopath("prioritise_on_focus")


-- local debugging = nil

local function stringify(value)
	if type(value) == "nil" then
		return "NIL"
	elseif type(value) == "boolean" then
		if value then
			return "TRUE"
		elseif not value then
			return "FALSE"
		else
			return "NIL"
		end
	elseif type(value) == "userdata" then
		return value.__typename
	else
		return value
	end
end

local function log(message)
--	print(message)
--	os.execute("echo >> /tmp/ion.log \"" .. message .. "\"")
--	File I/O might be a more reliable approach:
	local logfile = io.open("/tmp/ion.log", "a")
	logfile:write(stringify(message) .. "\n");
	logfile:close()
end

-- I guess this might vary, but IME it always seems to be 262.
local pid_property_atom = ioncore.x_intern_atom("_NET_WM_PID", false)

-- Function for determining the unix process ID of a given window (region).
-- NOTE: Ion's WClientWin and WWindow (and descendents) have an :xid(), but others don't, hence the type (and existence) checking before trying to map to the PID.
local function get_pid_of_region(region)
        if region ~= nil and (region.__typename == "WClientWin" or region.__typename == "WWindow") then
                return ioncore.x_get_window_property(region:xid(), pid_property_atom, 0, 0, true)[1]
        else
                return nil
        end
end


-- Obtain command name from process ID of its process
local function get_command_from_pid(pid)
        f=io.popen("ps -p " .. pid .. " -o comm=")
        local command = f:read("*l")
        io.close(f)
        return command
end



-- This will raise or lower the CPU and I/O scheduling priority of the process associated with the window, and is called by Ion whenever a region undergoes a change of focus (region_notify_hook).
local function adjust_priorities(region, event)
	-- We only need to do anything if the new region is actually an X client window and it's becoming active:
	if region == nil then
		log('adjust_priorities(): nil region; nothing to do.')
		return
	elseif region.__typename ~= "WClientWin" or (event ~= "activated" and event ~= "inactivated" and event ~= "pseudoactivated" and event ~= "pseudoinactivated")  then
	--	log('adjust_priorities(): irrelevant region type (' .. region.__typename .. ') or event type (' .. event .. ')')
		return
	end

	-- So far, so good...

	-- Are these necessary?  I think I added them for nil-avoidance (nils can cause some operations to fail).
	local pid = '-'
	local xid = '-'
	local command = '-'

	-- We know it's a WClientWin so no need for find_manager(); just get the window's PID.
	pid = get_pid_of_region(region)

	-- If that failed, give up now:
        if pid == nil then log("PID of region could not be determined!") return end


	-- Increase/decrease the process priority depending on whether we're entering or leaving:
	
	if (event == "activated") or (event == "pseudoactivated") then
		-- Give the foreground (active, in-focus) window's process a boost in CPU and I/O scheduling priority:
		log("PID " .. pid .. " +")
		os.execute("/usr/bin/sudo /usr/bin/renice -1 -p " .. pid)
		os.execute("/usr/bin/ionice -c 2 -n 0 -p " .. pid)
	elseif (event == "inactivated") or (event == "pseudoinactivated") then
		-- Lower the priorities of a window's process when it loses focus:
		log("PID " .. pid .. " -")
		os.execute("/usr/bin/renice +19 -p " .. pid)
		os.execute("/usr/bin/ionice -c 2 -n 7 -p " .. pid)
	else
		log("adjust_priorities: unhandled event type (" .. event .. "); doing nothing!")
		return
	end

	-- Since it's a related function, we also provide some statusbar monitors to show the currently-focussed PID, command name, Ion frame title, maybe workspace name as well.
	-- TODO...
end

-- Attach the function to Ion's region_notify_hook for detecting focus shifts:
ioncore.get_hook("region_notify_hook"):remove(adjust_priorities)
hook = ioncore.get_hook("region_notify_hook")
if hook then
    hook:add(adjust_priorities)
	print("adjust_priorities() hooked OK")
end

log("adjust_priorities() hooked to region_notify_hook")
log(ioncore.get_hook("region_notify_hook"):listed(adjust_priorities))


-- TODO: a statusbar/systray monitor to show the PID, Ion workspace title, frame title, whatever, of the current window.  Perhaps separate ones for each.
 
