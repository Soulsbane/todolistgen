local FileHandle, TodoFileName

function Initialize()
	FileUtils.RemoveFileFromOutputDir("default.css")

	FileHandle, TodoFileName = FileUtils.CreateTodoFile("html")
	print("Exporting list to " .. TodoFileName)

	FileHandle:write(FileReader.ReadText(Path.GetAddonDir() .. "/templates/default/header.html"))
end

function Deinitialize()
	FileHandle:write(FileReader.ReadText(Path.GetAddonDir() .. "/templates/default/footer.html"))
	FileUtils.CopyToOutputDir(Path.GetAddonDir() .. "/templates/default/default.css")
	io.close(FileHandle)

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
