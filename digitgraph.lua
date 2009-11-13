-- Single-character 0..1 meter

function digitgraph(value)
	if value >= 0.95 then return "!"
	elseif value >= 0.85 then return "9"
	elseif value >= 0.75 then return "8"
	elseif value >= 0.65 then return "7"
	elseif value >= 0.55 then return "6"
	elseif value >= 0.45 then return "5"
	elseif value >= 0.35 then return "4"
	elseif value >= 0.25 then return "3"
	elseif value >= 0.15 then return "2"
	elseif value >= 0.05 then return "1"
	else return "0"	-- or nil?
	end
end

