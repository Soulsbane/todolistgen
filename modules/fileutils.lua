local FileUtils = FileUtils

function IO.CreateTodoFile(fileExt)
	local fileName = Path:GetOutputDir() .. "/" .. Config.GetDefaultTodoFileName() .. "." .. fileExt
	fileHandle = io.open(fileName, "w+")

	return fileHandle, fileName
end

function FileUtils.CreateTodoFile(fileExt)
	return IO.CreateTodoFile(fileExt)
end

function IO.CreateFileInOutputDir(fileName, openMode)
	local mode = openMode or "w+"
	local fileHandle = io.open(Path.Normalize(Path:GetOutputDir(), fileName), mode)

	return fileHandle
end

return FileUtils
