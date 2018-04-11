local TemplateMod = require("resty.template")
local FileHandle, TodoFileName
local Normalize = Path.Normalize

function OnCreate()
	IO.RemoveFileFromOutputDir("default.css")

	FileHandle, TodoFileName = FileUtils.CreateTodoFile("html")
	FileHandle:write(IO.LoadTemplate("header.html", "default"))
end

function OnDestroy()
	FileHandle:write(IO.LoadTemplate("footer.html", "default"))
	IO.CopyFileToOutputDir(Normalize(Path.GetAddonTemplateDir(), "default", "default.css"))

	io.close(FileHandle)
	print("Exporting list to " .. TodoFileName)
end

function OnProcessTasks(tasks, fileName)
	local str = IO.LoadAndParseTemplate("tasks.tpl", {fileName = fileName, tasks = tasks}, "default")
	FileHandle:write(str)
end
