-- CME: adding this to get the backquote key to do this (even MORE like an FPS game!)

defbindings("WScreen", {
	bdoc("Toggle scratchpad."),
	kpress(META.."space", "mod_sp.set_shown_on(_, 'toggle')"),
	kpress(META.."grave", "mod_sp.set_shown_on(_, 'toggle')"),
})
