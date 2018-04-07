--local TemplateMod = require("etlua")
local TemplateMod = require("resty.template")
local FileHandle, TodoFileName, TasksTemplate
local Normalize = Path.Normalize
local DEFAULT_TEMPLATE_PATH = Normalize(Path.GetAddonDir(), "templates", "default")

function OnCreate()
	TasksTemplate = IO.ReadText(Normalize(DEFAULT_TEMPLATE_PATH, "tasks.elt"))
	IO.RemoveFileFromOutputDir("default.css")

	FileHandle, TodoFileName = FileUtils.CreateTodoFile("html")
	FileHandle:write(IO.ReadText(Normalize(DEFAULT_TEMPLATE_PATH, "header.html")))
end

function OnDestroy()
	FileHandle:write(IO.ReadText(Normalize(DEFAULT_TEMPLATE_PATH, "footer.html")))
	IO.CopyFileToOutputDir(Normalize(DEFAULT_TEMPLATE_PATH, "default.css"))

	io.close(FileHandle)
	print("Exporting list to " .. TodoFileName)
end

function OnProcessTasks(tasks, fileName)
	local func = TemplateMod.compile(TasksTemplate)
	local str = func({fileName = fileName, tasks = tasks})

	FileHandle:write(str)
end
