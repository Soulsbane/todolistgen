local FileHandle, TodoFileName

function Initialize()
	FileHandle, TodoFileName = FileUtils.CreateTodoFile("csv")

	print("Exporting list to " .. TodoFileName)
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
