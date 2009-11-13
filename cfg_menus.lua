-- I've placed menu definitions in a separate file from the original cfg_ioncore.lua (seems less confusing).
-- Bear in mind though that the activation of menus is done via bindings, so you'll typically have to edit this and cfg_bindings.lua at the same time.

-- The main things I've changed from the default are the inclusion of submenus for workspace and window lists, in case you don't want to use the keyboard for switching, and I revamped the main menu struture to be a bit more to my personal taste.

-- TODO: make use of the "focuslist" and/or "focuslist_" menus for browsing recent client windows that have been used.
-- TODO: implement a contextual window snapshot ("Snapshot this window") using xwd's -name facility.  It may be possible to get xwd metadata using the likes of "xwud -dumpheader -in /tmp/snap_2009_18599.xwd".


-- CME: new top-level main menu:
defmenu("main_menu", {
	submenu("System",	"system_menu"),
	submenu("Ion",		"ion_menu"),
	submenu("Applications",	"apps_menu"),
	submenu("Utilities",	"utils_menu"),
	submenu("Workspaces",	"workspacelist"),
	submenu("Windows",	"windowlist"),
	submenu("Recent",	"focuslist"),
})


-- CME: new menu structure:
defmenu("system_menu", {
	menuentry("Run Command...",	"mod_query.query_exec(_)"),
	menuentry("Help",		"mod_query.query_man(_)"),
	menuentry("Lock screen",    "ioncore.exec_on(_, 'xlock')"),
--	restart X
--	shutdown/reboot
})


-- CME: new menu structure:
defmenu("ion_menu", {
	menuentry("About Ion",		"mod_query.show_about_ion(_)"),
	submenu("Styles",		"stylemenu"),
--	submenu("Session",		"sessionmenu"),
	menuentry("Save",		"ioncore.snapshot()"),
	menuentry("Restart Ion",	"ioncore.restart()"),
	menuentry("Restart TWM",	"ioncore.restart_other('twm')"),
	menuentry("Exit",		"ioncore.shutdown()"),
})


defmenu("apps_menu", {
	menuentry("Terminal",       "ioncore.exec_on(_, XTERM or 'xterm')"),
--	Audio, Graphics, etc. submenus
})


defmenu("utils_menu", {
	menuentry("Window Screenshot",	"ioncore.exec_on(_, 'xwd -out /tmp/snap_`date +%Y-%m-%d_%H-%M-%S`_$$.xwd')"),	-- Would be kinda nice to get the window title in there as well! :^)  Maybe factor out a separate function for this, if we want to get fancy: extract metadata with xwud, covert to PNG, display, etc.
	menuentry("Magnifier",		"ioncore.exec_on(_, 'xmag')"),
	menuentry("Kill",		"ioncore.exec_on(_, 'xkill')"),	-- Hardly necessary, given Ion's existing kill capability.
})


-- Original main menu
defmenu("mainmenu", {
	menuentry("Run...",         "mod_query.query_exec(_)"),
	menuentry("Terminal",       "ioncore.exec_on(_, XTERM or 'xterm')"),
    menuentry("Lock screen",    "ioncore.exec_on(_, 'xlock')"),
    menuentry("Help",           "mod_query.query_man(_)"),
    menuentry("About Ion",      "mod_query.show_about_ion(_)"),
    submenu("Styles",           "stylemenu"),
    submenu("Session",          "sessionmenu"),
})


-- Session control menu
defmenu("sessionmenu", {
    menuentry("Save",           "ioncore.snapshot()"),
    menuentry("Restart",        "ioncore.restart()"),
    menuentry("Restart TWM",    "ioncore.restart_other('twm')"),
    menuentry("Exit",           "ioncore.shutdown()"),
})

-- I'd like a Tags submenu, but some of these functions are only applicable to certain types of object, so will try a couple of separate submenus.
-- tag_menu is deprecated; there are now separate submenus for different classes.
defmenu("tag_menu", {
	menuentry("Toggle Tag",	"WRegion.set_tagged(_, 'toggle')"),
	menuentry("Attach Tagged",	"ioncore.tagged_attach(_)"),
	menuentry("Clear Tag",		"ioncore.tagged_clear(_)"),

})

defmenu("wgroup_tag_menu", {
	menuentry("Toggle Tag",	"WRegion.set_tagged(_, 'toggle')"),
--	menuentry("Attach Tagged",	"ioncore.tagged_attach(_)"),
	menuentry("Clear Tag",		"ioncore.tagged_clear(_)"),
})

defmenu("wgroupws_tag_menu", {
--	menuentry("Toggle Tag",	"WRegion.set_tagged(_, 'toggle')"),
	menuentry("Attach Tagged",	"ioncore.tagged_attach(_)", {priority = 1}),	-- Want this to appear at the top of the merged Tags menu.  Bah, only they don't really merge.
--	menuentry("Clear Tag",		"ioncore.tagged_clear(_)"),
})


-- Context menu (frame actions etc.)
defctxmenu("WFrame", "Frame", {
	-- Note: this propagates the close to any subwindows; it does not
	-- destroy the frame itself, unless empty. An entry to destroy tiled
	-- frames is configured in cfg_tiling.lua.
	menuentry("Close Frame",          "WRegion.rqclose_propagate(_, _sub)"),
	-- CME: hey, shouldn't there be a rename frame entry here somewhere?  Maybe I deleted it accidentally once upon...
	menuentry("Rename Frame", "mod_query.query_renameframe(_)"),	-- CME
	menuentry("Window Info",   "mod_query.show_tree(_, _sub)"),	-- This is really more specialised than this, but I can't get it to work elsewhere.

	-- Simply a copy of main_menu
	submenu("System",	"system_menu"),
	submenu("Ion",		"ion_menu"),
	submenu("Applications",	"apps_menu"),
	submenu("Utilities",	"utils_menu"),
	submenu("Workspaces",   "workspacelist"),
	submenu("Windows",      "windowlist"),
	submenu("Recent",	"focuslist"),

--	submenu("Tags",	"tag_menu"),

    -- Low-priority entries
    -- TODO: make Toggle Tag and Attach Tag go together; maybe even create a Tag submenu.
--    menuentry("Attach tagged", "ioncore.tagged_attach(_)", { priority = 0 }),
--    menuentry("Clear tags",    "ioncore.tagged_clear()", { priority = 0 }),


})


-- Context menu for groups (workspaces, client windows)
defctxmenu("WGroup", "Group", {
--    menuentry("Toggle tag",     "WRegion.set_tagged(_, 'toggle')"),
    menuentry("WGroup De/reattach",    "ioncore.detach(_, 'toggle')"), 

	submenu("WGroup Tags",	"wgroup_tag_menu"),
})


-- Context menu for workspaces
defctxmenu("WGroupWS", "Workspace", {
    menuentry("WGroupWS Close",          "WRegion.rqclose(_)"),
    menuentry("WGroupWS Rename Workspace",         "mod_query.query_renameworkspace(nil, _)"),
--    menuentry("Attach tagged",  "ioncore.tagged_attach(_)"),

	submenu("WGroupWS Tags",	"wgroupws_tag_menu"),
})


-- Context menu for client windows
defctxmenu("WClientWin", "Client window", {
--	menuentry("WClientWin Window Info",   "mod_query.show_tree(_, _sub)"),	-- Doesn't work here with _sub as 2nd arg.  It's show_tree(mplex, reg, max_depth), BTW.
--	menuentry("WClientWin Close",          "WRegion.rqclose_propagate(_, _sub)"),
	submenu("WClientWin Tags",	"wgroupws_tag_menu"),
	menuentry("WClientWin Kill",           "WClientWin.kill(_)"),	-- CME: this should go just after Close
})




-- CME: TODO: see if you can add a "Move to Systray/Dock" menu entry to place an arbitrary client window into the statusbar (or dock?).  Wouldn't be needed very often.

