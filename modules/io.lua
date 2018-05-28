---Various fuctions for creating, reading and writing files.
local IO = IO

--[[--
	Creates a todo file using the fileExt parameter in the filename.
	@param fileExt The file extension to use for the todo file.
	@return A file handle to the created todo file and the constructed todo filename string.
]]
function IO.CreateTodoFile(fileExt)
	local fileName = Path.Normalize(Path.GetOutputDir(), Config.GetDefaultTodoFileName() .. "." .. fileExt)
	fileHandle = io.open(fileName, "w+")

	return fileHandle, fileName
end

--[[--
	Creates a file and returns the file handle to the file.
	@param fileName name of the file to create.
	@param openMode Mode in which to open the file.
	@return A file handle to the created file.
]]
function IO.CreateFile(fileName, openMode)
	local mode = openMode or "w+"
	local fileHandle = io.open(fileName, mode)

	return fileHandle
end

--[[--
	Creates a file in the users output directory and returns the file handle to the file.
	@param fileName name of the file to create.
	@param openMode Mode in which to open the file.
	@return A file handle to the created file.
]]
function IO.CreateFileInOutputDir(fileName, openMode)
	return IO.CreateFile(Path.Normalize(Path.GetOutputDir(), fileName), mode)
end

--[[--
	Creates a file in the addon directory and returns the file handle to the file.
	@param fileName name of the file to create.
	@param openMode Mode in which to open the file.
	@return A file handle to the created file.
]]
function IO.CreateFileInAddonDir(fileName, openMode)
	return IO.CreateFile(Path.Normalize(Path.GetAddonDir(), fileName), mode)
end

--[[--
	Creates a file in the addon's module directory and returns the file handle to the file.
	@param fileName name of the file to create.
	@param openMode Mode in which to open the file.
	@return A file handle to the created file.
]]
function IO.CreateFileInAddonModuleDir(fileName, openMode)
	return IO.CreateFile(Path.Normalize(Path.GetAddonModuleDir(), fileName), mode)
end

--[[--
	Creates a file in the base module directory and returns the file handle to the file.
	@param fileName name of the file to create.
	@param openMode Mode in which to open the file.
	@return A file handle to the created file.
]]
function IO.CreateFileInBaseAddonDir(fileName, openMode)
	return IO.CreateFile(Path.Normalize(Path.GetBaseAddonDir(), fileName), mode)
end

--[[--
	Loads a template and returns the resulting string.
	@param fileName name of the file to load.
	@return The loaded template as a string.
]]
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

--[[--
	Loads a template file and parses the result into a string.
	@param fileName name of the file to load and parse.
	@return The parsed template as a string.
]]
function IO.LoadAndParseTemplate(fileName, ...)
	local arguments = {...}

	if #arguments > 0 then
		if type(arguments[1]) == "table" then
			if (#arguments == 1) then --INFO Sending only a table as the last argument causes Normalize to error.
				local loadedTemplate = IO.LoadTemplate(fileName, arguments[1])
				local func = TemplateMod.compile(loadedTemplate)
				local str = func(arguments[1])

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

--INFO: The various write* functions should only be used if you need color in your output.
function IO.WriteLn(...)
	print(AnsiColors(...))
end

function IO.Write(...)
	io.write(AnsiColors(...))
end

function IO.WriteF(s, ...)
	io.write(AnsiColors(s:format(...)))
end

function IO.WriteFln(s, ...)
	io.write(AnsiColors(s:format(...)))
	io.write("\n")
end

return IO
