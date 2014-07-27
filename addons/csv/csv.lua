function ProcessTasks(tasks)
	local file = FileAPI()
	local fileName = file:createFile("todo.csv")

	print("Exporting list to..." .. fileName)

	for i, task in ipairs(tasks) do
		local output = task.fileName .. "," .. tostring(task.lineNumber) .. "," .. task.tag .. "," .. task.message
		file:writeLine(output)
	end
end
