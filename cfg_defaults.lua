--
-- Ion default settings
--
-- CME: copied from /usr/local/etc/ion3/cfg_defaults.lua for my own modification.

dopath("cfg_ioncore")
dopath("cfg_kludges")
dopath("cfg_layouts")

dopath("mod_query")
dopath("mod_menu")
dopath("mod_tiling")
-- Disable statusbar and enable dock to try to get Gnome/ROX/whatever panel working.  (I think these are mutually exclusive.)
dopath("mod_statusbar")
--dopath("mod_dock")
dopath("mod_sp")

-- Deprecated.
dopath("cfg_user", true)
