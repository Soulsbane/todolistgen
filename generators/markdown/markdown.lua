local FileHandle, TodoFileName

function Initialize()
	FileHandle, TodoFileName = FileUtils.CreateTodoFile("md")
end

function Deinitialize()
	io.close(FileHandle)
	print("Exporting list to " .. TodoFileName)
end

function ProcessTasks(tasks, fileName)
	FileHandle:write("## " .. fileName .. "\n")
	FileHandle:write("Tag | " .. "Line Number | " .. "Message" .. "\n")
	FileHandle:write("----| " .. "------------| " .. "-------" .. "\n")

	for i, task in ipairs(tasks) do
		FileHandle:write(task.tag .. " | " .. task.lineNumber .. "|" .. task.message .. "\n")
	end

	FileHandle:write("\n")
end
