-- CME: see cfg_ion.lua_disabled for maybe other settings to add back in here (I guess I borked something somewhere along the line and just disabled the whole chebang).
-- Actually, AFAICT, cfg_user.lua was deprecated in ~2006.
--
-- NOTE: see also cfg_ion.lua and cfg_ioncore.lua
--
-- <CME>
-- my local settings
print("running ~cedwards/.ion3/cfg_user.lua")


-- Set default modifiers. Alt should usually be mapped to Mod1 on
-- XFree86-based systems. The flying window keys are probably Mod3
-- or Mod4; see the output of 'xmodmap'.
META="mod4+"
--ALTMETA=""

ioncore.set{
	--dblclick_delay=250,
	--kbresize_delay=1500,
	opaque_resize=true,
	--warp=false,
	--default_ws_type="WIonWS",
}


--dopath("cfg_dock")	-- Now done in ~/.ion3/cfg_defaults.lua
--dopath("cfg_cedwards_gnome")
--dopath("cfg_cedwards_echomixer")
--dopath("cfg_cedwards_jack")
dopath("cfg_cedwards_system")
dopath("cfg_cedwards_bfilter")
dopath("cfg_cedwards_launcher")
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

-- </CME>

