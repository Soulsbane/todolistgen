local Helpers = Helpers

TemplateParser = require "resty.template"
AnsiColors = require "ansicolors"
---These functions are largely deprecated in favor of using the IO.* functions.

--[[--
	Parses a template and returns the result as a string.
	@param fileName Name of the file to parse.
]]
function Helpers.ParseTemplate(fileName)
	local func = TemplateParser.compile(Path.Normalize(Path.GetGeneratorTemplatesDir(), fileName))
	local str = func(_G) --Might be better to put their own table

	return str
end

--[[--
	Parses a template and writes the result to the passed output file name.
	@param outputFileName Name of the file to write the parsed results to.
	@param templateName Name of the template to parse.
]]
function Helpers.ParseAndCreateOutputFile(outputFileName, templateName)
	local data = Helpers.ParseTemplate(templateName)
	IO.CreateOutputFile(outputFileName, data)
end

return Helpers
