-- Drawing a pseudo-graphical bar gauge for statusbar display
-- ASCII values 16..20 look suitable (at least for aqui font):
-- 1->\016, 0.75->17 0.5->18, 0.25->19 0->\020
-- 0..12.5 -> \020
-- 12.5..37.5 -> \019


-- Shall we assume all values are between 0 and 100 (like, a percentage), or between 0 and 1 (nicer), or support arguments for minimum and maximum scale values?


function chargraph(value)
	if value < 0.125 then
		return "\020"
	elseif value >= 0.125 and value < 0.375 then
		return "\019"
	elseif value >= 0.375 and value < 0.625 then
		return "\018"
	elseif value >= 0.625 and value < 0.875 then
		return "\017"
	elseif value > 0.875 then
		return "\016"
	else
		return " "	-- or nil?
	end
end

