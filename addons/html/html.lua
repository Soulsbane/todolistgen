local FileHandle

function Initialize()
	FileUtils.RemoveFileFromOutputDir("todo.html")
	FileUtils.RemoveFileFromOutputDir("default.css")
	local fileName = Path.GetOutputDir() .. "/todo.html"
	FileHandle = io.open(fileName, "w+")

	print("Exporting list to " .. fileName)
	FileHandle:write(FileReader.ReadText(Path.GetAddonDir() .. "/templates/default/header.html"))
end

function Deinitialize()
	FileHandle:write(FileReader.ReadText(Path.GetAddonDir() .. "/templates/default/footer.html"))
	FileUtils.CopyToOutputDir(Path.GetAddonDir() .. "/templates/default/default.css")

end

local function WriteTags(...)
	for i,v in ipairs(arg) do
		FileHandle:write(v)
	end
end

function ProcessTasks(tasks, fileName)
	WriteTags("<table><caption><b>", fileName, "</b></caption>")
	FileHandle:write('<col width="10%"><col width="10%"><col width="80%">')
	FileHandle:write("<tr><th>Tag</th><th>Line Number</th><th>Message</th></tr>")

	for i, task in ipairs(tasks) do
		FileHandle:write("<tr>")
		WriteTags("<td>", task.tag, "</td>")
		WriteTags("<td>", tostring(task.lineNumber), "</td>")
		WriteTags("<td>", task.message, "</td>")
		FileHandle:write("</tr>")
	end

	FileHandle:write("</table><br/>")
end
