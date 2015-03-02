local FileWriter = FileWriter()

function Initialize()
	local fileUtils = FileUtils()

	fileUtils:removeFileFromOutputDir("todo.csv")
	outputFileName = FileWriter:openFile("todo.csv")
	print("Exporting list to " .. outputFileName)
end

function Deinitialize()
end

function ProcessTasks(tasks, fileName)
	for i, task in ipairs(tasks) do
		local output = task.fileName .. "," .. tostring(task.lineNumber) .. "," .. task.tag .. "," .. task.message
		FileWriter:writeLine(output)
	end
end
