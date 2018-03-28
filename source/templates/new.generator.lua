---Called before any tasks are processed.
function OnCreate()
end

---Called after all tasks have been processed.
function OnDestroy()
end

---Called once for each file that is processed.
--@param The list of tasks of the current file passed to this function.
--@param The current name of the file passed to this function.
--@param Whether this is the last file passed. True if it was false otherwise.
function OnProcessTasks(tasks, fileName, isLastFile)
end
