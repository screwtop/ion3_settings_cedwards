-- An Ion3 statusd meter for disk activity
-- Just a rough first stab, CME 2009-02-12

-- See http://modeemi.fi/~tuomov/ion-doc-3/ionconf/node6.html#SECTION00640000000000000000


-- Settings stuff:
local defaults={
	update_interval=1 * 1000,
}

local settings=table.join(statusd.get_config("iostat"), defaults)


-- Be nice and report a template:
statusd.inform("iostat_template", "xx0:000%")


-- Map values to status severity:
local function inform_iostat(iostat_value)
--	statusd.inform("iostat", "sda:" .. string.format("%03f", iostat_value) .. "%")	-- e.g. "sda:75%"
	statusd.inform("iostat", chargraph(iostat_value / 100))	-- charggraph
	if iostat_value > 80 then
		statusd.inform("iostat_hint", "critical")
	elseif iostat_value > 0 then
		statusd.inform("iostat_hint", "important")
	else
		statusd.inform("iostat_hint", "normal")
	end
end

-- Create timer
local iostat_timer=statusd.create_timer()

-- Get value and update
local function update_iostat()
	local iostat_value = 999
	-- Note: the first output is summary; need to wait for the second output for a proper reading.
	-- Here's a workaround: run iostat with two iterations, one per second, and grab the last line of output
	local f = io.popen("iostat -d sda -x -m 1 2 | grep sda | tail -n 1 | cut --bytes=99-")
	iostat_value = tonumber(f:read("*n"))
	os.execute("echo >/tmp/ion_iostat.txt " .. iostat_value)
	f:close()
	inform_iostat(iostat_value)
	iostat_timer:set(settings.update_interval, update_iostat)
end

update_iostat()

