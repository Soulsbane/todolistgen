function Initialize()
end

function Deinitialize()
end

function ProcessTasks(tasks, fileName)
	local fileWriter = FileWriter()
	local fileName = fileWriter:openFile("todo.csv")

	print("Exporting list to..." .. fileName)

	for i, task in ipairs(tasks) do
		local output = task.fileName .. "," .. tostring(task.lineNumber) .. "," .. task.tag .. "," .. task.message
		fileWriter:writeLine(output)
	end
end
