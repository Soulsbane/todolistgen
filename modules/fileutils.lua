local FileUtils = FileUtils

function FileUtils.RemoveFileFromAddonDir(fileName)
	local fileToRemove = Path.GetAddonDir() .. "/" .. fileName
	os.remove(fileToRemove)
end

function FileUtils.RemoveFileFromOutputDir(fileName)
	local fileToRemove = Path.GetOutputDir() .. "/" .. fileName
	os.remove(fileToRemove)
end

return FileUtils
