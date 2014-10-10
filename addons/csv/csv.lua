local fileWriter = FileWriter()
local outputFileName = fileWriter:openFile("todo.csv")

function Initialize()
	fileWriter = FileWriter()
	outputFileName = fileWriter:openFile("todo.csv")

	print("Exporting list to..." .. outputFileName)
end

function Deinitialize()
end

function ProcessTasks(tasks, fileName)
	for i, task in ipairs(tasks) do
		local output = task.fileName .. "," .. tostring(task.lineNumber) .. "," .. task.tag .. "," .. task.message
		fileWriter:writeLine(output)
	end
end
