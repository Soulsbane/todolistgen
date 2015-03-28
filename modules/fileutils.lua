local FileUtils = FileUtils

function FileUtils.RemoveFileFromOutputDir(fileName)
	local fileToRemove = Path.GetOutputDir() .. "/" .. fileName

	print("Removing File: ", fileToRemove)
	os.remove(fileToRemove)
end

return FileUtils
