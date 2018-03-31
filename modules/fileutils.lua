local FileUtils = FileUtils

function FileUtils.CreateTodoFile(fileExt)
	local fileName = Path:GetOutputDir() .. "/" .. Config.GetDefaultTodoFileName() .. "." .. fileExt
	fileHandle = io.open(fileName, "w+")

	return fileHandle, fileName
end

function IO.CreateTodoFile(fileExt)
	IO.CreateTodoFile(fileExt)
end

function IO.CreateFileInOutputDir(fileName, openMode)
	local mode = openMode or "w+"
	local fileHandle = io.open(Path.Normalize(Path:GetOutputDir(), fileName), mode)

	return fileHandle
end

return FileUtils
