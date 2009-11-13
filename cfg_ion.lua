-- Main Ion3 configuration file.
-- See cfg_ioncore.lua for keybindings and menu definitions.
-- Actually, I've now split that into cfg_bindings.lua and cfg_menus.lua, which now have to be included here specifically, I guess instead of ioncore.
-- Strictly speaking, should a cfg_X.lua files correspond to a mod_X?


-- "Windows" key or "Alt"?  Alt is easier to type with one hand, but collides with a lot of other software.  Little finger on Windows key is maybe OK.  It would put an otherwise pointless key to use, and free up the likes of Alt-F4 for closing windows (old habits...).
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
	opaque_resize=true,
	edge_resistance=200,	-- The default is so unrestrictive that I wasn't even aware of it!
	warp=false,
	--default_ws_type="WIonWS",
}


-- Essential/normal Ion stuff:
--dopath("cfg_defaults")
--dopath("cfg_ioncore")
dopath("cfg_menus.lua")
dopath("cfg_bindings.lua")
dopath("cfg_kludges")
dopath("cfg_layouts")

dopath("mod_query")
dopath("mod_menu")
dopath("mod_tiling")
dopath("mod_statusbar")
--dopath("mod_dock")
dopath("mod_sp")



-- Custom stuff:
--dopath("cfg_cedwards_gnome")
--dopath("cfg_cedwards_echomixer")
--dopath("cfg_cedwards_jack")
dopath("cfg_cedwards_system")
dopath("cfg_cedwards_bfilter")
dopath("winprops_desknerd")
dopath("cfg_cedwards_firefox")
dopath("cfg_cedwards_gvim")
dopath("cfg_cedwards_evolution")
--dopath("cfg_cedwards_ardour")
dopath("cfg_cedwards_gtkterm")
dopath("cfg_cedwards_fontforge")
dopath("change_priority_on_activation_change")

-- Testing socket interface for querying windows, workspaces, etc.
--dopath("execute_test")
--dopath("window_names")
--dopath("socket_test")

