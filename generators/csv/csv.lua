local FileHandle, TodoFileName

function OnCreate()
	FileHandle, TodoFileName = FileUtils.CreateTodoFile("csv")
end

function OnDestroy()
	io.close(FileHandle)
	print("Exporting list to " .. TodoFileName)
end

function OnProcessTasks(tasks, fileName)
	for i, task in ipairs(tasks) do
		local output = '"' .. task.fileName .. '"' .. "," .. tostring(task.lineNumber) ..  "," .. '"' .. task.tag .. '"' .. "," .. '"' .. task.message .. '"' .. "\n"
		FileHandle:write(output)
	end
end
