--Various functions that are missing from the Lua standard library.
AnsiColors = require "ansicolors"
TemplateMod = require("resty.template")

--Override resty.templates escape method since we don't need string escaping.
local function Escape(s, c)
	return s
end

TemplateMod.escape = Escape
--Global Date and Time variables for use in templates.
Month = os.date("%m")
Day = os.date("%d")
Year = os.date("%Y")

Hour = os.date("%I")
Hour24 = os.date("%H")
Minute = os.date("%M")
Second = os.date("%S")

Date = os.date("%x")
Time = string.format("%d:%d:%d", Hour, Minute, Second)
Time24 = os.date("%X")
DateAndTime = string.format("%s %s", Date, Time)
DateAndTime24 = os.date("%c")
AMOrPM = os.date("p")

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
