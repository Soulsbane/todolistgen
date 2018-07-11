--Various functions that are missing from the Lua standard library.
AnsiColors = require "ansicolors"
TemplateMod = require("resty.template")

--Override resty.templates escape method since we don't need string escaping.
local function Escape(s, c)
	return s
end

TemplateMod.escape = Escape

local function GetOrdinalIndicator(day)
	local lastDigit = day % 10

	if lastDigit == 1 and day ~= 11 then
		return "st"
	elseif lastDigit == 2 and day ~= 12 then
		return "nd"
	elseif lastDigit == 3 and day ~= 13 then
		return "rd"
	else
		return "th"
	end
end

--Global Date and Time variables for use in templates.
--NOTE: Since these are variables they are initialized once upon loading this module.
Date.Month = os.date("%m")
Date.Day = os.date("%d")
Date.Year = os.date("%Y")
Date.Now = os.date("%x")
Date.MonthName = os.date("%B")
Date.MonthNameShort = os.date("%b")
Date.Pretty = string.format("%s %d%s, %d", Date.MonthName, Date.Day, GetOrdinalIndicator(Date.Day), Date.Year)

Time.Hour = os.date("%I")
Time.Hour24 = os.date("%H")
Time.Minute = os.date("%M")
Time.Second = os.date("%S")
Time.Meridiem = os.date("%p") --AM or PM string.
Time.Now = string.format("%d:%d:%d", Time.Hour, Time.Minute, Time.Second)
Time.Now24 = os.date("%X")
Time.Pretty = string.format("%d:%s:%s%s", Time.Hour, Time.Minute, Time.Second, Time.Meridiem)

DateTime.Now = string.format("%s %s", Date.Now, Time.Now)
DateTime.Pretty = string.format("%s %s", Date.Pretty, Time.Pretty)
DateTime.Now24 = os.date("%c")

--[[--
	Get a slice of the given table.
	@param arr The array to get a slice from.
	@param first The first element that the slice should contain.
	@param last The last element that the slice should contain.
	@return The slice containing all elements from first to last.
]]
function table.slice(arr, first, last)
	local sub = {}

	for i = first, last do
		sub[#sub + 1] = arr[i]
	end

	return sub
end
