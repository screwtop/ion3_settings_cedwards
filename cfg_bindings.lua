-- I've moved key-/mouse-bindings definitions into this file, rather than lumping it into cfg_ioncore.lua with menu defs and other settings.


-- CME: some of my additions:
--  * Windows+W to politely close current window.
--  * Windows+Tab to cycle among workspaces.  (Would be nice to implement a stack push/pop thing to enable switching between two, and a graphical component so you can see where you are.)  Maybe also map Windows+M in memory of AmigaDOS.
--  * Full-screen toggle (maybe Windows+M[aximise] or Windows+F[ullscreen])

-- Define/Import map() function definition:
-- dopath("map")
-- Maybe not needed; just use map_events() below.
local function map(func, array)
  local new_array = {}
  for i,v in ipairs(array) do
    new_array[i] = func(v)
  end
  return new_array
end

-- The function needs to be parameterised, so we need a wrapper around map:
-- Oh, but how do we deal with the various functions that are used to define the event-action mappings?  We have kpress, mpress, maybe others.
-- Ah, maybe the table should consist of <function, event-string> pairs!  For example: {[kpress], WINDOWS.."W"}
-- 	map_events({
--		[kpress] = ALT.."F4",
--		[kpress] = WINDOWS.."W",
--	}, "WClientWin.rqclose(_)"),
-- Hmm, no, that doesn't actually work, for some reason.  Maybe because the kpress function needs to return a value that then gets placed in the table being passed to defbindings().
local function map_events(event_table, action)
	return_values = {}
	for event_function, event_string in pairs(event_table) do
		print("mapping " .. event_string .. " -> " .. action)
		table.insert(return_values, event_function(event_string, action))
	end
	return return_values
end

-- 
-- Bindings. This includes global bindings and bindings common to
-- screens and all types of frames only. See modules' configuration 
-- files for other bindings.
--


-- WScreen context bindings
--
-- The bindings in this context are available all the time.
--
-- The variable META should contain a string of the form 'Mod1+'
-- where Mod1 maybe replaced with the modifier you want to use for most
-- of the bindings. Similarly ALTMETA may be redefined to add a 
-- modifier to some of the F-key bindings.

defbindings("WScreen", {
    bdoc("Switch to n:th object (workspace, full screen client window) "..
         "within current screen."),
    kpress(META.."1", "WScreen.switch_nth(_, 0)"),
    kpress(META.."2", "WScreen.switch_nth(_, 1)"),
    kpress(META.."3", "WScreen.switch_nth(_, 2)"),
    kpress(META.."4", "WScreen.switch_nth(_, 3)"),
    kpress(META.."5", "WScreen.switch_nth(_, 4)"),
    kpress(META.."6", "WScreen.switch_nth(_, 5)"),
    kpress(META.."7", "WScreen.switch_nth(_, 6)"),
    kpress(META.."8", "WScreen.switch_nth(_, 7)"),
    kpress(META.."9", "WScreen.switch_nth(_, 8)"),
    kpress(META.."0", "WScreen.switch_nth(_, 9)"),
    
    bdoc("Switch to next/previous object within current screen."),
    kpress(META.."comma", "WScreen.switch_prev(_)"),
    kpress(META.."period", "WScreen.switch_next(_)"),

    submap(META.."K", {
        bdoc("Go to first region demanding attention or previously active one."),
        kpress("K", "mod_menu.grabmenu(_, _sub, 'focuslist')"),
        -- Alternative without (cyclable) menu
        --kpress("K", "ioncore.goto_activity() or ioncore.goto_previous()"),

        --bdoc("Go to previous active object."),
        --kpress("K", "ioncore.goto_previous()"),
        
        --bdoc("Go to first object on activity/urgency list."),
        --kpress("I", "ioncore.goto_activity()"),
        
        bdoc("Clear all tags."),
        kpress("T", "ioncore.tagged_clear()"),
    }),

    bdoc("Go to n:th screen on multihead setup."),
    kpress(META.."Shift+1", "ioncore.goto_nth_screen(0)"),
    kpress(META.."Shift+2", "ioncore.goto_nth_screen(1)"),
    
    bdoc("Go to next/previous screen on multihead setup."),
    kpress(META.."Shift+comma", "ioncore.goto_prev_screen()"),
    kpress(META.."Shift+period", "ioncore.goto_next_screen()"),
    
    bdoc("Create a new workspace of chosen default type."),
    kpress(META.."F9", "ioncore.create_ws(_)"),

	-- CME: adding this from cfg_sp.lua
--	kpress(META.."grave", "mod_sp.set_shown_on(_, 'toggle')"),
--	Actually, see ~/.ion3/cfg_sp.lua, which is really the correct place to put this as it depends on whether mod_sp is even enabled.

    
    bdoc("Display the main menu."),
	kpress("Menu", "mod_query.query_menu(_, _sub, 'main_menu', 'Main menu:')"),	-- CME: adding "Menu" key functionality, and my new main menu.
	--kpress("Menu", "mod_query.pmenu(_, _sub, 'mainmenu')"),	-- CME: adding "Menu" key functionality
    kpress(ALTMETA.."F12", "mod_query.query_menu(_, _sub, 'mainmenu', 'Main menu:')"),
    --kpress(ALTMETA.."F12", "mod_menu.menu(_, _sub, 'mainmenu', {big=true})"),
    --mpress("Button3", "mod_menu.pmenu(_, _sub, 'mainmenu')"),
    mpress("Button3", "mod_menu.pmenu(_, _sub, 'main_menu')"),
    
    bdoc("Display the window list menu."),
    mpress("Button2", "mod_menu.pmenu(_, _sub, 'windowlist')"),

    bdoc("Forward-circulate focus."),
    -- '_chld' used here stands to for an actual child window that may not
    -- be managed by the screen itself, unlike '_sub', that is likely to be
    -- the managing group of that window. The right/left directions are
    -- used instead of next/prev, because they work better in conjunction
    -- with tilings.
    kpress(META.."Tab", "ioncore.goto_next(_chld, 'right')", 
           "_chld:non-nil"),
    submap(META.."K", { 
        bdoc("Backward-circulate focus."),
        kpress("AnyModifier+Tab", "ioncore.goto_next(_chld, 'left')", 
               "_chld:non-nil"),
        
        bdoc("Raise focused object, if possible."),
        kpress("AnyModifier+R", "WRegion.rqorder(_chld, 'front')",
               "_chld:non-nil"),
    }),

})


-- Client window bindings
--
-- These bindings affect client windows directly.

defbindings("WClientWin", {
    bdoc("Nudge the client window. This might help with some "..
         "programs' resizing problems."),
    kpress_wait(META.."L", "WClientWin.nudge(_)"),

	-- CME: Alt-F4 to close current window.
	kpress(ALT.."F4", "WClientWin.rqclose(_)"),
	-- CME: actually, Windows+W would also be appropriate for this.
	kpress(WINDOWS.."w", "WClientWin.rqclose(_)"),
	-- CME: had hoped this would allow multiple key bindings to be defined at once, but no. :(
--	map_events({
--		[kpress] = ALT.."F4",
--		[kpress] = WINDOWS.."W",
--	}, "WClientWin.rqclose(_)"),
	
    
    submap(META.."K", {
       bdoc("Kill client owning the client window."),
       kpress("C", "WClientWin.kill(_)"),
       
       bdoc("Send next key press to the client window. "..
            "Some programs may not allow this by default."),
       kpress("Q", "WClientWin.quote_next(_)"),
    }),
})


-- Client window group bindings

defbindings("WGroupCW", {
    bdoc("Toggle client window group full-screen mode"),
    kpress_wait(META.."Return", "WGroup.set_fullscreen(_, 'toggle')"),
})


-- WMPlex context bindings
--
-- These bindings work in frames and on screens. The innermost of such
-- contexts/objects always gets to handle the key press. 

defbindings("WMPlex", {
    bdoc("Close current object."),
    kpress_wait(META.."C", "WRegion.rqclose_propagate(_, _sub)"),
    
    submap(META.."K", {
        bdoc("Detach (float) or reattach an object to its previous location."),
        -- By using _chld instead of _sub, we can detach/reattach queries
        -- attached to a group. The detach code checks if the parameter 
        -- (_chld) is a group 'bottom' and detaches the whole group in that
        -- case.
        kpress("D", "ioncore.detach(_chld, 'toggle')", "_chld:non-nil"),
    }),
})

-- Frames for transient windows ignore this bindmap

defbindings("WMPlex.toplevel", {
    bdoc("Toggle tag of current object."),
    kpress(META.."T", "WRegion.set_tagged(_sub, 'toggle')", "_sub:non-nil"),

    bdoc("Query for manual page to be displayed."),
    kpress(ALTMETA.."F1", "mod_query.query_man(_, ':man')"),

    bdoc("Show the Ion manual page."),
    kpress(META.."F1", "ioncore.exec_on(_, ':man ion3')"),

    bdoc("Run a terminal emulator."),
    kpress(ALTMETA.."F2", "ioncore.exec_on(_, XTERM or 'urxvt -e bash -l')"),
    
    bdoc("Query for command line to execute."),
    kpress(ALTMETA.."F3", "mod_query.query_exec(_)"),

    bdoc("Query for Lua code to execute."),
    kpress(META.."F3", "mod_query.query_lua(_)"),

    bdoc("Query for host to connect to with SSH."),
    kpress(ALTMETA.."F4", "mod_query.query_ssh(_, ':ssh')"),

    bdoc("Query for file to edit."),
    kpress(ALTMETA.."F5", 
           "mod_query.query_editfile(_, 'run-mailcap --action=edit')"),

    bdoc("Query for file to view."),
    kpress(ALTMETA.."F6", 
           "mod_query.query_runfile(_, 'run-mailcap --action=view')"),

    bdoc("Query for workspace to go to or create a new one."),
    kpress(ALTMETA.."F9", "mod_query.query_workspace(_)"),
    
    bdoc("Query for a client window to go to."),
    kpress(META.."G", "mod_query.query_gotoclient(_)"),
    
    bdoc("Display context menu."),
    --kpress(META.."M", "mod_menu.menu(_, _sub, 'ctxmenu')"),
    kpress(META.."M", "mod_query.query_menu(_, _sub, 'ctxmenu', 'Context menu:')"),
})


-- WFrame context bindings
--
-- These bindings are common to all types of frames. Some additional
-- frame bindings are found in some modules' configuration files.

defbindings("WFrame", {
    submap(META.."K", {
        bdoc("Maximize the frame horizontally/vertically."),
        kpress("H", "WFrame.maximize_horiz(_)"),
        kpress("V", "WFrame.maximize_vert(_)"),
    }),
    
    bdoc("Display context menu."),
    mpress("Button3", "mod_menu.pmenu(_, _sub, 'ctxmenu')"),
    
    bdoc("Begin move/resize mode."),
    kpress(META.."R", "WFrame.begin_kbresize(_)"),
    
    bdoc("Switch the frame to display the object indicated by the tab."),
    mclick("Button1@tab", "WFrame.p_switch_tab(_)"),
    mclick("Button2@tab", "WFrame.p_switch_tab(_)"),
    
    bdoc("Resize the frame."),
    mdrag("Button1@border", "WFrame.p_resize(_)"),
    mdrag(META.."Button3", "WFrame.p_resize(_)"),
    
    bdoc("Move the frame."),
    mdrag(META.."Button1", "WFrame.p_move(_)"),
    
    bdoc("Move objects between frames by dragging and dropping the tab."),
    mdrag("Button1@tab", "WFrame.p_tabdrag(_)"),
    mdrag("Button2@tab", "WFrame.p_tabdrag(_)"),

	-- CME:
    kpress(META.."J", "ioncore.goto_next(_, 'next')"),
	-- What about 'prev'/'previous'? 
})

-- Frames for transient windows ignore this bindmap

defbindings("WFrame.toplevel", {
    bdoc("Query for a client window to attach."),
    kpress(META.."A", "mod_query.query_attachclient(_)"),
    
    submap(META.."K", {
        -- Display tab numbers when modifiers are released
        submap_wait("ioncore.tabnum.show(_)"),
        
        bdoc("Switch to n:th object within the frame."),
        kpress("1", "WFrame.switch_nth(_, 0)"),
        kpress("2", "WFrame.switch_nth(_, 1)"),
        kpress("3", "WFrame.switch_nth(_, 2)"),
        kpress("4", "WFrame.switch_nth(_, 3)"),
        kpress("5", "WFrame.switch_nth(_, 4)"),
        kpress("6", "WFrame.switch_nth(_, 5)"),
        kpress("7", "WFrame.switch_nth(_, 6)"),
        kpress("8", "WFrame.switch_nth(_, 7)"),
        kpress("9", "WFrame.switch_nth(_, 8)"),
        kpress("0", "WFrame.switch_nth(_, 9)"),
        
        bdoc("Switch to next/previous object within the frame."),
        kpress("N", "WFrame.switch_next(_)"),
        kpress("P", "WFrame.switch_prev(_)"),
        
        bdoc("Move current object within the frame left/right."),
        kpress("comma", "WFrame.dec_index(_, _sub)", "_sub:non-nil"),
        kpress("period", "WFrame.inc_index(_, _sub)", "_sub:non-nil"),
               
        bdoc("Maximize the frame horizontally/vertically."),
        kpress("H", "WFrame.maximize_horiz(_)"),
        kpress("V", "WFrame.maximize_vert(_)"),

        bdoc("Attach tagged objects to this frame."),
        kpress("A", "ioncore.tagged_attach(_)"),
    }),
})

-- Bindings for floating frames.

defbindings("WFrame.floating", {
    bdoc("Toggle shade mode"),
    mdblclick("Button1@tab", "WFrame.set_shaded(_, 'toggle')"),
    
    bdoc("Raise the frame."),
    mpress("Button1@tab", "WRegion.rqorder(_, 'front')"),
    mpress("Button1@border", "WRegion.rqorder(_, 'front')"),
    mclick(META.."Button1", "WRegion.rqorder(_, 'front')"),
    
    bdoc("Lower the frame."),
    mclick(META.."Button3", "WRegion.rqorder(_, 'back')"),
    
    bdoc("Move the frame."),
    mdrag("Button1@tab", "WFrame.p_move(_)"),
})


-- WMoveresMode context bindings
-- 
-- These bindings are available keyboard move/resize mode. The mode
-- is activated on frames with the command begin_kbresize (bound to
-- META.."R" above by default).

defbindings("WMoveresMode", {
    bdoc("Cancel the resize mode."),
    kpress("AnyModifier+Escape","WMoveresMode.cancel(_)"),

    bdoc("End the resize mode."),
    kpress("AnyModifier+Return","WMoveresMode.finish(_)"),

    bdoc("Grow in specified direction."),
    kpress("Left",  "WMoveresMode.resize(_, 1, 0, 0, 0)"),
    kpress("Right", "WMoveresMode.resize(_, 0, 1, 0, 0)"),
    kpress("Up",    "WMoveresMode.resize(_, 0, 0, 1, 0)"),
    kpress("Down",  "WMoveresMode.resize(_, 0, 0, 0, 1)"),
    kpress("F",     "WMoveresMode.resize(_, 1, 0, 0, 0)"),
    kpress("B",     "WMoveresMode.resize(_, 0, 1, 0, 0)"),
    kpress("P",     "WMoveresMode.resize(_, 0, 0, 1, 0)"),
    kpress("N",     "WMoveresMode.resize(_, 0, 0, 0, 1)"),
    
    bdoc("Shrink in specified direction."),
    kpress("Shift+Left",  "WMoveresMode.resize(_,-1, 0, 0, 0)"),
    kpress("Shift+Right", "WMoveresMode.resize(_, 0,-1, 0, 0)"),
    kpress("Shift+Up",    "WMoveresMode.resize(_, 0, 0,-1, 0)"),
    kpress("Shift+Down",  "WMoveresMode.resize(_, 0, 0, 0,-1)"),
    kpress("Shift+F",     "WMoveresMode.resize(_,-1, 0, 0, 0)"),
    kpress("Shift+B",     "WMoveresMode.resize(_, 0,-1, 0, 0)"),
    kpress("Shift+P",     "WMoveresMode.resize(_, 0, 0,-1, 0)"),
    kpress("Shift+N",     "WMoveresMode.resize(_, 0, 0, 0,-1)"),
    
    bdoc("Move in specified direction."),
    kpress(META.."Left",  "WMoveresMode.move(_,-1, 0)"),
    kpress(META.."Right", "WMoveresMode.move(_, 1, 0)"),
    kpress(META.."Up",    "WMoveresMode.move(_, 0,-1)"),
    kpress(META.."Down",  "WMoveresMode.move(_, 0, 1)"),
    kpress(META.."F",     "WMoveresMode.move(_,-1, 0)"),
    kpress(META.."B",     "WMoveresMode.move(_, 1, 0)"),
    kpress(META.."P",     "WMoveresMode.move(_, 0,-1)"),
    kpress(META.."N",     "WMoveresMode.move(_, 0, 1)"),
})


-- CME: NOTE: this stuff has to go in cfg_statusbar.lua in order to work!
-- CME: adding binding for context menu on statusbar.  "WStatusBar" doesn't seem to be recognised. :^(  Nor "WInfoWin".
-- But supposedly WStatusBar is recognised:
-- http://www.modeemi.cs.tut.fi/~tuomov/ion-doc-3/ionconf/node4.html#sec:bindings
--ioncore.defbindings("WStatusBar", {
--    bdoc("Switch to n:th object (workspace, full screen client window) within current screen."),
--	kpress(META.."1", "WScreen.switch_nth(_, 0)"),
--	mpress("Button3", "mod_menu.pmenu(_, _sub, 'ion_menu')"),
--})
