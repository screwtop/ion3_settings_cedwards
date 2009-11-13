-- Main Ion3 configuration file.
-- See cfg_ioncore.lua for keybindings and menu definitions.


-- "Windows" key or "Alt"?  Alt is easier to type with one hand, but collides with a lot of other software.  Little finger on Windows key is maybe OK.  It would put an otherwise pointless key to use, and free up the likes of Alt-F4 for closing windows (old habits...).
SHIFT="shift+"
CTRL="control+"
ALT="Mod1+"
WINDOWS="Mod4+"
WINDOWS_L="Super_L+"
META=WINDOWS
--META="Mod4+"	
--META=WINDOWS_L	-- No, gives "insane key combination" error.
ALTMETA=""
MENU="Menu"	-- Hardly seems necessary!


ioncore.set{
	--dblclick_delay=250,
	--kbresize_delay=1500,
	opaque_resize=true,
	warp=false,
	--default_ws_type="WIonWS",
}


-- Essential/normal Ion stuff:
--dopath("cfg_defaults")
dopath("cfg_ioncore")
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

