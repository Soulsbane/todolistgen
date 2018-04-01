local FileUtils = FileUtils

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

return FileUtils
