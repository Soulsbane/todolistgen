local FileHandle, TodoFileName

local function WriteTags(tagName, value)
	FileHandle:write("\t\t<" .. tagName .. ">" .. value .. "</" .. tagName .. ">\n")
end

function OnCreate()
	FileHandle, TodoFileName = FileUtils.CreateTodoFile("xml")
	FileHandle:write([[<?xml version="1.0" encoding="UTF-8"?>]])
	FileHandle:write('\n<todo version="1.0">\n')
end

function OnDestroy()
	FileHandle:write("</todo>\n")
	io.close(FileHandle)
	print("Exporting list to " .. TodoFileName)
end

function OnProcessTasks(tasks, fileName)
	FileHandle:write("<tasks fileName=" .. '"' .. fileName .. '">\n')

	for i, task in ipairs(tasks) do
		FileHandle:write("\t<task>\n")
		WriteTags("tag", task.tag)
		WriteTags("linenumber", task.lineNumber)
		WriteTags("message", task.message)
		FileHandle:write("\t</task>\n")
	end

	FileHandle:write("</tasks>\n")
end
