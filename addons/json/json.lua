local FileWriter = FileWriter()

function Initialize()
	local fileName = FileWriter:openFile("todo.json")

	print("Exporting list to..." .. fileName)
	FileWriter:writeLine("{")
end

function Deinitialize()
	FileWriter:writeLine("}")
end

function ProcessTasks(tasks, fileName)
		FileWriter:writeLine(string.format("\t%q: [" , fileName))

		for i, task in pairs(tasks) do

			FileWriter:writeLine("\t{")

			FileWriter:writeLine(string.format("\t\t%q: %d,", "lineNumber", task.lineNumber))
			FileWriter:writeLine(string.format("\t\t%q: %q,", "message", task.message))
			FileWriter:writeLine(string.format("\t\t%q: %q", "tag", task.tag))

			if(i == #tasks) then
				FileWriter:writeLine("\t}")
			else
				FileWriter:writeLine("\t},")
			end
		end
		FileWriter:writeLine("\t],")
end

