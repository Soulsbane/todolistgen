local TemplateMod = require("etlua")
local FileHandle, TodoFileName, TasksTemplate
local DEFAULT_TEMPLATE_PATH = Path.GetAddonDir() .. "/templates/default/"

function Initialize()
	TasksTemplate = FileReader.ReadText(DEFAULT_TEMPLATE_PATH .. "tasks.elt")
	FileUtils.RemoveFileFromOutputDir("default.css")

	FileHandle, TodoFileName = FileUtils.CreateTodoFile("html")
	print("Exporting list to " .. TodoFileName)

	FileHandle:write(FileReader.ReadText(DEFAULT_TEMPLATE_PATH .. "header.html"))
end

function Deinitialize()
	FileHandle:write(FileReader.ReadText(DEFAULT_TEMPLATE_PATH .. "footer.html"))
	FileUtils.CopyFileToOutputDir(DEFAULT_TEMPLATE_PATH .. "default.css")

	io.close(FileHandle)
end

function ProcessTasks(tasks, fileName)
	local template = TemplateMod.compile(TasksTemplate)
	FileHandle:write((template({ fileName = fileName, tasks = tasks })))
end
