local FileWriter = FileWriter()

function Initialize()
	local path = Path()
	local fileReader = FileReader()
	local fileName = FileWriter:openFile("todo.html")

	print("Exporting list to..." .. fileName)
	FileWriter:writeLine(fileReader:readText(path:getAddonDir() .. "/templates/default/header.html"))
end

function Deinitialize()
	local path = Path()
	local fileReader = FileReader()
	local fileUtils = FileUtils()

	FileWriter:writeLine(fileReader:readText(path:getAddonDir() .. "/templates/default/footer.html"))
	fileUtils:copyToOutputDir(path:getAddonDir() .. "/templates/default/default.css")

end

local function WriteTags(...)
	for i,v in ipairs(arg) do
		FileWriter:writeLine(v)
	end
end

function ProcessTasks(tasks, fileName)
	WriteTags("<table><caption>", fileName, "</caption>")
	FileWriter:writeLine("<tr><th>Line Number</th><th>Message</th><th>Tag</th></tr>")

	for i, task in ipairs(tasks) do
		FileWriter:writeLine("<tr>")
		WriteTags("<td>", tostring(task.lineNumber), "</td>")
		WriteTags("<td>", task.message, "</td>")
		WriteTags("<td>", task.tag, "</td>")
		FileWriter:writeLine("</tr>")
	end

	FileWriter:writeLine("</table>")
end
