local FileUtils = FileUtils

function FileUtils.CreateTodoFile(fileExt)
	local fileName = Path:GetOutputDir() .. "/" .. Config.GetDefaultTodoFileName() .. "." .. fileExt
	fileHandle = io.open(fileName, "w+")

	return fileHandle, fileName
end

return FileUtils
