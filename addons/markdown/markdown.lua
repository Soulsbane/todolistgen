function ProcessTask(task)
	print(task.fileName, task.lineNumber, task.tag, task.message)
end

function ProcessTasks(tasks)
	for i, task in ipairs(tasks) do
		print(task.fileName, task.lineNumber, task.tag, task.message)
	end
end
