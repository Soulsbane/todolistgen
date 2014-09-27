function ProcessTasks(tasks, size)
	local output = {}

	for i, task in ipairs(tasks) do
		if(output[task.fileName]) then
			table.insert(output[task.fileName], task)
		else
			output[task.fileName] = {}
			table.insert(output[task.fileName], task)
		end
	end

	for fileName, _ in pairs(output) do
		print(fileName, "\n")
		for outputKey, outputValue in pairs(output[fileName]) do
			for taskTableKey, taskTableValue in pairs(outputValue) do --INFO: This loops through a task table that is stored in filename key
				print("K3: ", taskTableKey, " V3: ", taskTableValue)
			end
			print("\n")
		end
		print("================================================")
	end

	local file = FileAPI()
	local fileReader = FileReader()

	print("^^^^", file:getInstallDir())
	print("^^^^", file:getBaseAddonDir())
	print("^^^^", file:getAddonDir())
	print(fileReader:readText(file:getInstallDir() .. "/README.md"))
end


