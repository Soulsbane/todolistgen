local FileHandle, TodoFileName

function OnCreate()
	FileHandle, TodoFileName = IO.CreateTodoFile("csv")
end

function OnDestroy()
	io.close(FileHandle)
	print("Exporting list to " .. TodoFileName)
end

function OnProcessTasks(tasks, fileName)
	local str = IO.LoadAndParseTemplate("tasks.tpl", {fileName = fileName, tasks = tasks})
	FileHandle:write(str)
end
