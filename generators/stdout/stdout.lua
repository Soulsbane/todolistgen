function OnCreate()
end

function OnDestroy()
end

function OnProcessTasks(tasks, fileName, isLastFile)
	for i, task in ipairs(tasks) do
		print(task.fileName, task.lineNumber, task.tag, task.message)
	end
end
