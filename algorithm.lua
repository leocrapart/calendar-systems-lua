bisextile = false

function generate_bion_days()
	local alphabet = "abcdefghijklmnopqrstuvwxyz"
	local days = {}
	-- first half
	for i = 1, #alphabet do
		local letter = alphabet:sub(i, i)
		table.insert(days, letter .. "ion")
	end

	-- second half
	for i = 1, #alphabet do
		local letter = alphabet:sub(i, i)
		table.insert(days, letter .. "ion bis")
	end
	return days
end


bion_days = generate_bion_days()
function print_bion_days()
	for i, day in ipairs(bion_days) do
		print(i, day)
	end
end
-- print_bion_days()

function generate_bion_calendar(bisextile)
	local calendar = {}
	local bion_cycles = {"1er cycle", "2e cycle", "3e cycle",
			   "4e cycle", "5e cycle", "6e cycle", 
			   "7e cycle"}
	for i, cycle in ipairs(bion_cycles) do
		for j, day in ipairs(bion_days) do
			table.insert(calendar, day .. " " .. cycle)
		end
	end
	table.insert(calendar, "reset")
	if bisextile then
		table.insert(calendar, "super reset")
	end
	return calendar
end

-- bion_calendar = generate_bion_calendar(bisextile)
function print_bion_calendar()
	for i, day in ipairs(bion_calendar) do
		print(i, day)
	end
end
-- print_bion_calendar()



function generate_normal_calendar(bisextile)
	local calendar = {}
	local days_in_fevrier = 28
	if bisextile then
		days_in_fevrier = days_in_fevrier + 1
	end
	local days_in_months = {["Janvier"] = 31,
							["Février"] = days_in_fevrier,
							["Mars"] = 31,
							["Avril"] = 30,
							["Mai"]= 31,
							["Juin"] = 30,
							["Juillet"] = 31,
							["Août"] = 31,
							["Septembre"] = 30,
							["Novembre"] = 31,
							["Octobre"] = 30,
							["Décembre"] = 31}
	local months = {"Janvier",
					"Février",
					"Mars",
					"Avril",
					"Mai",
					"Juin",
					"Juillet",
					"Août",
					"Septembre",
					"Novembre",
					"Octobre",
					"Décembre"}
	for _, month in ipairs(months) do
		local days_in_month = days_in_months[month]
		for i = 1, days_in_month do
			table.insert(calendar, "" .. i .. " " .. month)
		end
	end
	return calendar
end

-- normal_calendar = normal_calendar(bisextile)
-- for i, day in ipairs(normal_calendar) do
-- 	print(i, day)
-- end

-- api
function normal_day_to_bion_day(normal_day)
	local day_number = 0
	local normal_calendar = generate_normal_calendar(bisextile)
	local bion_calendar = generate_bion_calendar(bisextile)
	-- find day_number
	for i, day in ipairs(normal_calendar) do
		if day == normal_day then
			day_number = i
		end
	end
	day_not_found = day_number == 0
	if day_not_found then 
		print("normal day not found in normal_calendar")
	end
	return bion_calendar[day_number]
end

-- api
function bion_day_to_normal_day(bion_day)
	local day_number = 0
	local normal_calendar = generate_normal_calendar(bisextile)
	local bion_calendar = generate_bion_calendar(bisextile)
	-- find day_number
	for i, day in ipairs(bion_calendar) do
		if day == bion_day then
			day_number = i
		end
	end
	day_not_found = day_number == 0
	if day_not_found then 
		print("bion day not found in bion_calendar")
	end
	return normal_calendar[day_number]
end


function test_bijection()
	test_normal_days_bijection()
	test_bion_days_bijection()
end

function test_normal_days_bijection()
	local normal_calendar = generate_normal_calendar(bisextile)
	for _, normal_day in ipairs(normal_calendar) do
		local double_converted_normal_day = 
			bion_day_to_normal_day(
				normal_day_to_bion_day(normal_day))
		assertion = normal_day == double_converted_normal_day
		if not assertion then
			print("expected", normal_day, " actual ", double_converted_normal_day)
		end
	end
end

function test_bion_days_bijection()
	local bion_calendar = generate_bion_calendar(bisextile)
	for _, bion_day in ipairs(bion_calendar) do
		local double_converted_bion_day = 
			normal_day_to_bion_day(
				bion_day_to_normal_day(bion_day))
		assertion = bion_day == double_converted_bion_day
		if not assertion then
			print("expected", bion_day, " actual ", double_converted_bion_day)
		end
	end
end

function test_length()
	-- bisextile
	bisextile = true
	local normal_calendar = generate_normal_calendar(bisextile)
	local bion_calendar = generate_bion_calendar(bisextile)
	
	local good_number_normal_days = #normal_calendar == 366
	local good_number_bion_days = #bion_calendar == 366

	if not good_number_normal_days then
		print("expected 366 normal days for bisextile year", " actual ", #normal_calendar)
	end
	if not good_number_bion_days then
		print("expected 366 bion days for bisextile year  ", " actual ", #bion_calendar)
	end

	-- not bisextile
	bisextile = false
	local normal_calendar = generate_normal_calendar(bisextile)
	local bion_calendar = generate_bion_calendar(bisextile)

	local good_number_normal_days = #normal_calendar == 365
	local good_number_bion_days = #bion_calendar == 365

	if not good_number_normal_days then
		print("expected 365 normal days", " actual ", #normal_calendar)
	end
	if not good_number_bion_days then
		print("expected 365 bion days  ", " actual ", #bion_calendar)
	end

end

test_bijection()
test_length()

