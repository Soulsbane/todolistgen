local FileWriter = FileWriter()
local FileReader = FileReader()
local Path = Path()

function Initialize()
	local fileName = FileWriter:openFile("todo.html")

	print("Exporting list to " .. fileName)
	FileWriter:write(FileReader:readText(Path:getAddonDir() .. "/templates/default/header.html"))
end

function Deinitialize()
	local fileUtils = FileUtils()

	FileWriter:write(FileReader:readText(Path:getAddonDir() .. "/templates/default/footer.html"))
	fileUtils:copyToOutputDir(Path:getAddonDir() .. "/templates/default/default.css")

end

local function WriteTags(...)
	for i,v in ipairs(arg) do
		FileWriter:write(v)
	end
end

function ProcessTasks(tasks, fileName)
	WriteTags("<table><caption><b>", fileName, "</b></caption>")
	FileWriter:write('<col width="10%"><col width="10%"><col width="80%">')
	FileWriter:write("<tr><th>Tag</th><th>Line Number</th><th>Message</th></tr>")

	for i, task in ipairs(tasks) do
		FileWriter:write("<tr>")
		WriteTags("<td>", task.tag, "</td>")
		WriteTags("<td>", tostring(task.lineNumber), "</td>")
		WriteTags("<td>", task.message, "</td>")
		FileWriter:write("</tr>")
	end

	FileWriter:write("</table><br/>")
end
