local FileUtils = FileUtils
local TemplateMod = require("resty.template")

local function slice(arr, first, last)
	local sub = {}

	for i = first, last do
		sub[#sub + 1] = arr[i]
	end

	return sub
end

function IO.CreateTodoFile(fileExt)
	local fileName = Path.Normalize(Path.GetOutputDir(), Config.GetDefaultTodoFileName() .. "." .. fileExt)
	fileHandle = io.open(fileName, "w+")

	return fileHandle, fileName
end

function FileUtils.CreateTodoFile(fileExt)
	return IO.CreateTodoFile(fileExt)
end

function IO.CreateFile(fileName, openMode)
	local mode = openMode or "w+"
	local fileHandle = io.open(fileName, mode)

	return fileHandle
end

function IO.CreateFileInOutputDir(fileName, openMode)
	return IO.CreateFile(Path.Normalize(Path.GetOutputDir(), fileName), mode)
end

function IO.CreateFileInAddonDir(fileName, openMode)
	return IO.CreateFile(Path.Normalize(Path.GetAddonDir(), fileName), mode)
end

function IO.CreateFileInAddonModuleDir(fileName, openMode)
	return IO.CreateFile(Path.Normalize(Path.GetAddonModuleDir(), fileName), mode)
end

function IO.CreateFileInBaseAddonDir(fileName, openMode)
	return IO.CreateFile(Path.Normalize(Path.GetBaseAddonDir(), fileName), mode)
end

function IO.LoadTemplate(fileName, ...)
	local arguments = {...}

	if #arguments > 0 then
		if type(arguments[1]) == "table" then
			local temp = Path.Normalize(Path.GetAddonTemplateDir(), select(2, ...))
			return IO.ReadText(Path.Normalize(temp, fileName))
		else
			local temp = Path.Normalize(Path.GetAddonTemplateDir(), select(1, ...))
			return IO.ReadText(Path.Normalize(temp, fileName))
		end
	else
		return IO.ReadText(Path.Normalize(Path.GetAddonTemplateDir(), fileName))
	end
end

function IO.LoadAndParseTemplate(fileName, ...)
	local arguments = {...}

	if #arguments > 0 then
		if type(arguments[1]) == "table" then
			if (#arguments == 1) then --INFO Sending only a table as the last argument causes Normalize to error.
				local loadedTemplate = IO.LoadTemplate(fileName, arguments[1])
				local func = TemplateMod.compile(loadedTemplate)
				local str = func({})

				return str
			else
				local loadedTemplate = IO.LoadTemplate(fileName, select(2, ...))
				local func = TemplateMod.compile(loadedTemplate)
				local str = func(arguments[1]) --The table arg

				return str
			end
		else
			local loadedTemplate = IO.LoadTemplate(fileName, ...)
			local func = TemplateMod.compile(loadedTemplate)
			local str = func({})

			return str
		end
	else
		local loadedTemplate = IO.LoadTemplate(fileName, ...)
		local func = TemplateMod.compile(loadedTemplate)
		local str = func({})

		return str
	end
end

return FileUtils
