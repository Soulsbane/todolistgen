local File = FileAPI()

local function WriteTags(...)
	for i,v in ipairs(arg) do
		File:writeLine(v)
	end
end

function ProcessTasks(tasks)
	local output = {}
	local fileName = File:createFile("todo.html")

	print("Exporting list to..." .. fileName)

	for i, task in ipairs(tasks) do
		if(output[task.fileName]) then
			table.insert(output[task.fileName], task)
		else
			output[task.fileName] = {}
			table.insert(output[task.fileName], task)
		end
	end

	File:writeLine("<html><title></title><head><style>table, th, td {border: 1px solid black;border-collapse: collapse;}")
	File:writeLine("table{width: 100%;} th, td {border: 1px solid black;border-collapse: collapse;}")
	File:writeLine("th, td {padding: 5px;text-align: left;}</style></head>")
	File:writeLine("<body>")

	for fileName, _ in pairs(output) do
		WriteTags("<table><caption>", fileName, "</caption")
		File:writeLine("<tr><th>Line Number</th><th>Message</th><th>Tag</th></tr>")

		for outputKey, outputValue in pairs(output[fileName]) do
			File:writeLine("<tr>")
			for taskTableKey, taskTableValue in pairs(outputValue) do --INFO: This loops through a task table that is stored in filename key
				if(taskTableKey ~= "fileName") then
					WriteTags("<td>", tostring(taskTableValue), "</td>")
				end
			end
			File:writeLine("</tr>")
		end
		File:writeLine("</table>")
	end
	File:writeLine("</body></html>")
end
