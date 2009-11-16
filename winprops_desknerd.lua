-- TODO: come up with a name for this whole thing ("DeskNerd"?).

-- Does "name" correspond to "WClientWin"?  Yes, I guess it does - it works!
-- is_dockapp rather than statusbar???

defwinprop{
	class = "Test.tcl",
	instance = "test.tcl",
	name = "ion3_statusbar_systray_test",
--	target = "web-browser",
--	transient_mode = "on",	-- Should be set already; doesn't matter, AFAICT.
	statusbar = 'systray',
--	switchto = "true",	
}

-- OK, so far so good! Let's implement a few of these:

defwinprop{
	class = "Files.tcl",
	instance = "files.tcl",
	name = "DeskNerd_Files",
	statusbar = "systray_files",
}

defwinprop{
	class = "Launcher.tcl",
	instance = "launcher.tcl",
	name = "DeskNerd_Launcher",
	statusbar = "systray_launcher",
}

-- Time, date, calendar, weather, tides, moon phases, etc.
-- What to call this?  "Environment"?  "World"?
defwinprop{
	class = "Time.tcl",
	instance = "time.tcl",
	name = "DeskNerd_Time",
	statusbar = "systray_time",
}


-- Performance meter(s):
defwinprop{
--	class = "Sda.tcl",
--	instance = "sda.tcl",
	name = "DeskNerd_IOMeter.*",
	statusbar = "systray_monitor_io",
}

defwinprop{
	class = "Cpu.tcl",
	instance = "cpu.tcl",	-- NOTE: you can't use wildcards with instance, only name! :(
	name = "DeskNerd_CPUMeter.*",
	statusbar = "systray_monitor_cpu",
}

defwinprop{
	class = "Memory.tcl",
	instance = "memory.tcl",
	name = "DeskNerd_MemoryMeter.*",
	statusbar = "systray_monitor_ram",
}

defwinprop{
	class = "Jack.tcl",
	instance = "jack.tcl",
	name = "DeskNerd_JACK.*",
	statusbar = "systray_jack",
}


-- No longer needed, now that the CPU meters are implemented in a single script:
defwinprop { class = "Cpu.tcl", instance = "cpu.tcl #2", name = "DeskNerd_CPUMeter.*", statusbar = "systray_monitor_cpu", }
defwinprop { class = "Cpu.tcl", instance = "cpu.tcl #3", name = "DeskNerd_CPUMeter.*", statusbar = "systray_monitor_cpu", }
defwinprop { class = "Cpu.tcl", instance = "cpu.tcl #4", name = "DeskNerd_CPUMeter.*", statusbar = "systray_monitor_cpu", }

-- Or should it be systray_notification or systray_notifications?
defwinprop { name = "DeskNerd_Notifier.*", statusbar = "systray_notifier", }
defwinprop { name = "DeskNerd_InstaLauncher.*", statusbar = "systray_instalaunch", }

