-- Lua os.execute test; really a basic test to see how Lua functions behaves when called from within ion's startup routine.  Want to avoid blocking.
-- OK, can confirm this just runs and doesn't impede Ion in any measurable way.  Alt-F3 to run Lua functions from within Ion, BTW.

os.execute("touch /tmp/ion_lua_" .. os.time())

function log_time()
	os.execute("logger 'Ion3: " .. os.time() .. "'")
end

