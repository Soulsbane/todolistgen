local FileHandle

function Initialize()
	local fileName = Path:GetOutputDir() .. "/todo.csv"

	FileUtils.RemoveFileFromOutputDir(fileName)
	FileHandle = io.open(fileName, "w+")

	print("Exporting list to " .. fileName)
end

function Deinitialize()
	io.close(FileHandle)
end

function ProcessTasks(tasks, fileName)
	for i, task in ipairs(tasks) do
		local output = task.fileName .. "," .. tostring(task.lineNumber) .. "," .. task.tag .. "," .. task.message .. "\n"
		FileHandle:write(output)
	end
end
