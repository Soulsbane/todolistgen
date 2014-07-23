function ProcessTasks(tasks)
	local fileName = file.getOutputPath() .. "/todo.csv"
	local csvFile = io.open(fileName, "w+")

	io.output(csvFile)
	print("Exporting list to..." .. fileName)

	for i, task in ipairs(tasks) do
		io.write(task.fileName, ",", task.lineNumber, ",", task.tag, ",", task.message, "\n")
	end

	io.close(csvFile)
end
