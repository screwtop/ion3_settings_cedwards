-- Report hostname of system


-- Handle settings and defaults:
local defaults={
	-- Hehe, probably never need to update normally
    update_interval=60*1000,
}

local settings=table.join(statusd.get_config("hostname"), defaults)


--statusd.inform("hostname_template", "xxx:000%")

local function inform_hostname(hostname)
	statusd.inform("hostname", hostname)
	if hostname==nil then
		statusd.inform("hostname_hint", "critical")
    else
		statusd.inform("hostname_hint", "normal")
	end
end


local hostname_timer=statusd.create_timer()


local function update_hostname()
	print("update_hostname() called")
	f=io.popen("hostname --short")	-- Do we want IP address as well?  Separate statusd handler?
	local hostname = f:read("*l")
	io.close(f)
	print("hostname="..hostname)
	inform_hostname(hostname)
	hostname_timer:set(settings.update_interval, update_hostname)
end


update_hostname()

