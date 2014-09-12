function ProcessTasks(tasks)
	local output = {}
	local file = FileAPI()
	local fileName = file:createFile("todo.html")

	print("Exporting list to..." .. fileName)

	for i, task in ipairs(tasks) do
		if(output[task.fileName]) then
			table.insert(output[task.fileName], task)
		else
			output[task.fileName] = {}
			table.insert(output[task.fileName], task)
		end
	end

	file:writeLine("<html><title></title><style>table, th, td {border: 1px solid black;border-collapse: collapse;}")
	file:writeLine("table{width: 100%;} th, td {border: 1px solid black;border-collapse: collapse;}")
	file:writeLine("th, td {padding: 5px;text-align: left;}</style>")
	file:writeLine("<body>")

	for fileName, _ in pairs(output) do
		file:writeLine("<table>")
		file:writeLine("<caption>")
		file:writeLine(fileName)
		file:writeLine("</caption>")
		file:writeLine("<tr><th>Line Number</th><th>Message</th><th>Tag</th></tr>")

		for outputKey, outputValue in pairs(output[fileName]) do
			file:writeLine("<tr>")
			for taskTableKey, taskTableValue in pairs(outputValue) do --INFO: This loops through a task table that is stored in filename key
				if(taskTableKey ~= "fileName") then
					file:writeLine("<td>")
					file:writeLine(tostring(taskTableValue))
					file:writeLine("</td>")
				end
			end
			file:writeLine("</tr>")
		end
		file:writeLine("</table></body></html>")
	end
end
