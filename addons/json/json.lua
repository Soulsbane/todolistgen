local FileHandle

function Initialize()
	local fileName = Path.GetOutputDir() .. "/todo.json"

	FileUtils.RemoveFileFromOutputDir("todo.json")
	FileHandle = io.open(fileName, "w+")

	print("Exporting list to " .. fileName)
	FileHandle:write("{\n")
end

function Deinitialize()
	FileHandle:write("}\n")
	io.close(FileHandle)
end

function ProcessTasks(tasks, fileName, lastFile)
		FileHandle:write(string.format("\t%q: [\n" , fileName))

		for i, task in pairs(tasks) do

			FileHandle:write("\t{\n")

			FileHandle:write(string.format("\t\t%q: %d,\n", "lineNumber", task.lineNumber))
			FileHandle:write(string.format("\t\t%q: %q,\n", "message", task.message))
			FileHandle:write(string.format("\t\t%q: %q\n", "tag", task.tag))

			if(i == #tasks) then
				FileHandle:write("\t}\n")
			else
				FileHandle:write("\t},\n")
			end
		end
		if lastFile then
			FileHandle:write("\t]\n")
		else
			FileHandle:write("\t],\n")
		end
end

