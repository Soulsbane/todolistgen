local TemplateMod = require("etlua")
local FileHandle, TodoFileName, TasksTemplate
local Normalize = Path.Normalize
local DEFAULT_TEMPLATE_PATH = Normalize(Path.GetAddonDir(), "templates", "default")

function Initialize()
	TasksTemplate = FileReader.ReadText(Normalize(DEFAULT_TEMPLATE_PATH, "tasks.elt"))
	Path.RemoveFileFromOutputDir("default.css")

	FileHandle, TodoFileName = FileUtils.CreateTodoFile("html")
	FileHandle:write(FileReader.ReadText(Normalize(DEFAULT_TEMPLATE_PATH, "header.html")))
end

function Deinitialize()
	FileHandle:write(FileReader.ReadText(Normalize(DEFAULT_TEMPLATE_PATH, "footer.html")))
	Path.CopyFileToOutputDir(Normalize(DEFAULT_TEMPLATE_PATH, "default.css"))

	io.close(FileHandle)
	print("Exporting list to " .. TodoFileName)
end

function ProcessTasks(tasks, fileName)
	local template = TemplateMod.compile(TasksTemplate)
	FileHandle:write((template({ fileName = fileName, tasks = tasks })))
end
