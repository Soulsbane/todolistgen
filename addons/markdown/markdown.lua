local FileHandle

function Initialize()
	local fileName = Path.GetOutputDir() .. "/todo.md"
	FileHandle = io.open(fileName, "w+")

	print("Exporting list to " .. fileName)
end

function Deinitialize()
	io.close(FileHandle)
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
