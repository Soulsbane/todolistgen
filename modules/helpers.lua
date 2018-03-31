local Helpers = Helpers

TemplateParser = require "resty.template"
AnsiColors = require "ansicolors"

function Helpers.ParseTemplate(fileName)
	local func = TemplateParser.compile(Path.Normalize(Path.GetGeneratorTemplatesDir(), fileName))
	local str = func(_G) --Might be better to put their own table

	return str
end

function Helpers.ParseAndCreateOutputFile(outputFileName, templateName)
	local data = Helpers.ParseTemplate(templateName)
	IO.CreateOutputFile(outputFileName, data)
end

return Helpers
