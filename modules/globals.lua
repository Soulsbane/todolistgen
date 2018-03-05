--Various functions that are missing from the Lua standard library.
AnsiColors = require "ansicolors"

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

--INFO: The various write* functions should only be used if you need color in your output.
function writeln(...)
	print(AnsiColors(...))
end

function write(...)
	io.write(AnsiColors(...))
end

function writef(s, ...)
	io.write(AnsiColors(s:format(...)))
end

function writefln(s, ...)
	io.write(AnsiColors(s:format(...)))
	io.write("\n")
end
