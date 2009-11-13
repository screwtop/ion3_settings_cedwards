-- Ion status monitor for current CPU clock speed courtesy of temp-info
-- NOTE: this is broken somehow; not sure exactly but it keeps statusd from running.

-- Handle settings and defaults:
local defaults={
    update_interval=2500,
}
                
local settings=table.join(statusd.get_config("temp"), defaults)


statusd.inform("temp_template", "xxxxx")

local function inform_temp(temp)
	statusd.inform("temp", temp)
	local temp_value = tonumber(string.sub(temp, 2, 3))
	print(temp_value)
--	os.execute("echo >> /tmp/ion.log Temperature " .. temp_value)
	if temp_value > 65 then
		statusd.inform("temp_hint", "critical")
	elseif temp_value > 45 then
		statusd.inform("temp_hint", "important")
	else
		statusd.inform("temp_hint", "normal")
	end
end


local temp_timer=statusd.create_timer()


local function update_temp()
	f=io.popen("nice -n 1  /usr/bin/sensors | grep temp1 | cut --bytes=14-")
	local temp = f:read("*l")
	io.close(f)
	inform_temp(temp)
	temp_timer:set(settings.update_interval, update_temp)
end


update_temp()

