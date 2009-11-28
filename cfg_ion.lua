-- This is the main Ion3 configuration file.
-- See cfg_ioncore.lua for keybindings and menu definitions, but actually, I've now split that into cfg_bindings.lua and cfg_menus.lua, which now have to be included here specifically, instead of cfg_ioncore.lua.  My configuration also doesn't use cfg_defaults.lua, including those items explicitly/directly here.
-- (Strictly speaking, should a cfg_X.lua files correspond to a mod_X?)


-- "Windows" key or "Alt"?  Alt is easier to type with one hand, but collides with a lot of other software.  Left-hand little finger on Windows key is maybe OK.  It would put an otherwise pointless key to use, and free up the likes of Alt-F4 for closing windows (old habits...).
SHIFT="Shift+"
CTRL="Control+"
ALT="Mod1+"
WINDOWS="Mod4+"	-- This IS case-sensitive, and should be "Mod" even though xmodmap says "mod".
WINDOWS_L="Super_L+"
--WINDOWS_R="Super_R+"
--??="Hyper_L+"
META=WINDOWS
--META="Mod4+"	
--META=WINDOWS_L	-- No, gives "insane key combination" error.
ALTMETA=""
MENU="Menu"	-- Hardly seems necessary!


ioncore.set{
	--dblclick_delay=250,
	--kbresize_delay=1500,
	opaque_resize=false,	-- Nice if it weren't generally so sluggish.
	edge_resistance=200,	-- The default is so unrestrictive that I wasn't even aware of it!
	warp=false,
	--default_ws_type="WIonWS",
}


-- Preferred terminal emulator
XTERM="urxvt"


-- Essential/normal Ion stuff:
--dopath("cfg_defaults")	-- Loads cfg_ioncore, menus, bindings, kludges, layouts, and the mod_ files.
--dopath("cfg_ioncore")	-- Defines menus and bindings, which I've now separated as below:
dopath("cfg_menus.lua")
dopath("cfg_bindings.lua")
dopath("cfg_kludges")
dopath("cfg_layouts")
--dopath("cfg_user")	-- DEPRECATED!


-- Settings for various modules
dopath("mod_query")
dopath("mod_menu")
dopath("mod_tiling")
dopath("mod_statusbar")
--dopath("mod_dock")
dopath("mod_sp")


-- Additional third-party scripts I downloaded and installed (CME)
-- dopath("ctrl_statusbar")
--dopath("exec_show")
--dopath("document_menus")	-- Not sure if this even works...
--dopath("frame_client_menu")
--dopath("send_to_ws")
--dopath("cfg_mouse")	-- Needs WScratchpad?


-- Custom stuff:
dopath("cfg_cedwards_gnome")

dopath("cfg_cedwards_gtkterm")

dopath("cfg_cedwards_echomixer")
dopath("cfg_cedwards_jack")
dopath("cfg_cedwards_qjackctl")
dopath("cfg_cedwards_ardour")
dopath("cfg_cedwards_baudline")
dopath("cfg_cedwards_jkmeter")

dopath("cfg_cedwards_system")
dopath("cfg_cedwards_bfilter")
dopath("cfg_cedwards_desknerd")
dopath("winprops_desknerd")

dopath("cfg_cedwards_firefox")
dopath("cfg_cedwards_firefox3")
dopath("cfg_cedwards_thunderbird")
dopath("cfg_cedwards_evolution")

dopath("cfg_cedwards_gvim")
dopath("cfg_cedwards_fontforge")

dopath("prioritise_on_focus")
--dopath("change_priority_on_activation_change")	-- TODO: rename this something like "focus_priority" and post to the scripts archive.

-- Testing socket interface for querying windows, workspaces, etc.
--dopath("execute_test")
--dopath("window_names")
--dopath("socket_test")

