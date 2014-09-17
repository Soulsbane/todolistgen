function ProcessTasks(tasks, size)
	for i, task in ipairs(tasks) do
		print(task.fileName, task.lineNumber, task.tag, task.message)
	end
end
