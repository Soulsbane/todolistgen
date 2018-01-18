function Initialize()
end

function Deinitialize()
end

function ProcessTasks(tasks, fileName)
	for i, task in ipairs(tasks) do
		print(task.fileName, task.lineNumber, task.tag, task.message)
	end
end
