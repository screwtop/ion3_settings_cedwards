-- Simple Lua sockets demo: an echo server.
-- http://www.tecgraf.puc-rio.br/~diego/professional/luasocket/introduction.html

--function echo_server()

-- load namespace
local socket = require("socket")

-- create a TCP socket and bind it to the local host, at any port
local server = assert(socket.bind("*", 0))

-- find out which port the OS chose for us
local ip, port = server:getsockname()

-- print a message informing what's up
print("Please telnet to localhost on port " .. port)
print("After connecting, you have 10s to enter a line to be echoed")

-- loop forever waiting for clients
while 0 do
	-- wait for a connection from any client
	print("	waiting for client connection...")
	local client = server:accept()

	-- make sure we don't block waiting for this client's line
	print("	client connected; activating 10 s timeout...")
	client:settimeout(10)

	-- receive the line
	local line, err = client:receive()
	print("	received data.")

  -- if there was no error, send it back to the client
	if not err then client:send(line .. "\n") end

  -- done with client, close the object
	client:close()
	print("	client connection closed.")
end

-- Is the fact that this loops indefinitely (potentially blocking all the while) gonna be a probalo?

--end


