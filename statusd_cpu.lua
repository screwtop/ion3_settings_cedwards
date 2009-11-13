-- An Ion3 statusd meter for CPU activity
-- Uses dstat to enable separate statistics for each CPU on an MP system.
-- Just a rough first stab, CME 2009-02-16
-- Can we provide multiple meters from a single statusd script?

--[[ dstat format:
-------cpu0-usage--------------cpu1-usage--------------cpu2-usage--------------cpu3-usage------
usr sys idl wai hiq siq:usr sys idl wai hiq siq:usr sys idl wai hiq siq:usr sys idl wai hiq siq
]]

-- See http://modeemi.fi/~tuomov/ion-doc-3/ionconf/node6.html#SECTION00640000000000000000


dopath("chargraph")
dopath("digitgraph")

-- Settings stuff:
local defaults={
    update_interval= 2 * 1000, -- Each dstat invocation requires at least one second
}

local settings=table.join(statusd.get_config("cpu"), defaults)


-- Be nice and report a template:
-- TODO: for loop
--for cpu_id = 0,3 do
--	statusd.inform("cpu_" .. cpu_id .. "_template", "CPU" .. cpu_id .. ":999%")
--end


statusd.inform("cpu_0_template", "cpu0:000%")
statusd.inform("cpu_1_template", "cpu1:000%")
statusd.inform("cpu_2_template", "cpu2:000%")
statusd.inform("cpu_3_template", "cpu3:000%")


-- Map values to status severity:
local function inform_cpu(cpu_value, cpu_id)
	-- Might be nicer to just report the number, and leave labels etc. to the statusbar template (with 4+ CPUs it can take a fair bit of space)
--	statusd.inform("cpu_" .. cpu_id, "CPU" .. cpu_id .. ":" .. tostring(cpu_value) .. "%")
--	statusd.inform("cpu_" .. cpu_id, string.format("%03u", cpu_value))	-- Why does this not work?  We want the number padded to 3 characters always.  Maybe ion trims spaces destined for the statubar.
	statusd.inform("cpu_" .. cpu_id, chargraph(cpu_value / 100))	-- Chargraph; quite nice
--	statusd.inform("cpu_" .. cpu_id, digitgraph(cpu_value / 100))
	if cpu_value > 80 then
		statusd.inform("cpu_" .. cpu_id .. "_hint", "critical")
	elseif cpu_value > 20 then
		statusd.inform("cpu_" .. cpu_id .. "_hint", "important")
	else
		statusd.inform("cpu_" .. cpu_id .. "_hint", "normal")
	end
end


-- Create timer
local cpu_timer=statusd.create_timer()


-- Get value and update
local function update_cpu()
	-- Note: the first output is summary; need to wait for the second output for a proper reading.
	local f = io.popen("dstat --cpu -C 0,1,2,3 --noheaders --nocolor 1 1 | tail -n 1")
	local line = f:read("*l")
	f:close()

	-- TODO: nest these in the inform_cpu calls
	for cpu_id = 0,3 do
	--	inform_cpu(cpu_id, cpu_id)
		inform_cpu(tonumber(string.sub(line, cpu_id * 24 + 1, cpu_id * 24 + 3) + string.sub(line, cpu_id * 24 + 5, cpu_id * 24 + 7)), cpu_id)

		-- Sanity check: should equal 100%
	--	inform_cpu(tonumber(string.sub(line, cpu_id * 24 + 1, cpu_id * 24 + 3) + string.sub(line, cpu_id * 24 + 5, cpu_id * 24 + 7) + string.sub(line, cpu_id * 24 + 9, cpu_id * 24 + 11) + string.sub(line, cpu_id * 24 + 13, cpu_id * 24 + 15)), cpu_id)
	end

	cpu_timer:set(settings.update_interval, update_cpu)
end

update_cpu()

