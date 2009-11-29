-- Simple Ion3 statusbar component to display the current workspace name.

-- But, of course, each screen will have its own current workspace...
-- ...but at least each screen can have its own statusbar, so it may be possible to display the current workspace name for each screen on the screen's statusbar.

ioncore.warn("Loading statusbar_current_workspace.lua ...")


--local function workspace_changed_handler(region, event)
local function workspace_changed_handler(parameter_table)

	-- We only need to do anything if the new region is actually an X client window and it's becoming active...
	-- Um, think about this: for workspaces, only bother updating if we've switched workspaces.  For frames, we may need to update on every frame refocus.  So this will vary.
	--
	-- Also, could region ever be null?  Would it matter?
	if parameter_table.reg == nil then
		ioncore.warn("current_workspace: Region was nil!")
		return
	end

--	ioncore.warn(parameter_table.mode)	-- Generally "switchonly", or "add" when starting up.

	if parameter_table.sw then
		ioncore.defer(function()
			mod_statusbar.inform('current_workspace_name', ioncore.find_manager(parameter_table.sub, "WGroupWS"):name())
			mod_statusbar.update()
		end)
	end
end


-- Attach the handler function to the event.  NOTE: should this be using screen_managed_changed_hook rather than region_notify_hook?
ioncore.get_hook("screen_managed_changed_hook"):remove(workspace_changed_handler)
hook = ioncore.get_hook("screen_managed_changed_hook")
if hook then
	hook:add(workspace_changed_handler)
	if ioncore.get_hook("screen_managed_changed_hook"):listed(workspace_changed_handler) then
		ioncore.warn("workspace_changed_handler() hooked OK.")
		mod_statusbar.update()
	else
		ioncore.warn("FAILED to hook workspace_changed_handler()!")
	end
end


