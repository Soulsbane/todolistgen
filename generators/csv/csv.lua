local FileHandle, TodoFileName

function Initialize()
	FileHandle, TodoFileName = FileUtils.CreateTodoFile("csv")
end

function Deinitialize()
	io.close(FileHandle)
	print("Exporting list to " .. TodoFileName)
end

function ProcessTasks(tasks, fileName)
	for i, task in ipairs(tasks) do
		local output = '"' .. task.fileName .. '"' .. "," .. tostring(task.lineNumber) ..  "," .. '"' .. task.tag .. '"' .. "," .. '"' .. task.message .. '"' .. "\n"
		FileHandle:write(output)
	end
end
