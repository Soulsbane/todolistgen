local FileWriter = FileWriter()

function Initialize()
	local fileName = FileWriter:openFile("todo.md")
	print("Exporting list to..." .. fileName)
end

function Deinitialize()
end

function ProcessTasks(tasks, fileName)
	FileWriter:writeLine("## " .. fileName)
	FileWriter:writeLine("Tag | " .. "Line Number | " .. "Message")
	FileWriter:writeLine("----| " .. "------------| " .. "-------")

	for i, task in ipairs(tasks) do
		FileWriter:writeLine(task.tag .. " | " .. task.lineNumber .. "|" .. task.message)
	end

	FileWriter:writeLine("\n")
end
