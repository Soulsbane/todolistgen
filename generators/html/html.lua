local TemplateMod = require("resty.template")
local FileHandle, TodoFileName, TasksTemplate
local Normalize = Path.Normalize

function OnCreate()
	TasksTemplate = IO.LoadTemplate("tasks.tpl", "default")
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
	local func = TemplateMod.compile(TasksTemplate)
	local str = func({fileName = fileName, tasks = tasks})

	FileHandle:write(str)
end
