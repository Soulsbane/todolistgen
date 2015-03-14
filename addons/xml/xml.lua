local function WriteTags(tagName, value)
	FileWriter:writeLine("\t\t<" .. tagName .. ">" .. value .. "</" .. tagName .. ">")
end

function Initialize()
	FileUtils:removeFileFromOutputDir("todo.xml")
	local fileName = FileWriter:openFile("todo.xml")

	print("Exporting list to " .. fileName)
	FileWriter:writeLine([[<?xml version="1.0" encoding="UTF-8"?>]])
	FileWriter:writeLine("<todo>")
end

function Deinitialize()
	FileWriter:writeLine("</todo>")
end

function ProcessTasks(tasks, fileName)
	FileWriter:writeLine("\t<task fileName=" .. "\"" .. fileName .. "\">")

	for i, task in ipairs(tasks) do
		WriteTags("tag", task.tag)
		WriteTags("linenumber", task.lineNumber)
		WriteTags("message", task.message)
	end

	FileWriter:writeLine("\t</task>")
end
