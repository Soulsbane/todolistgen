local FileHandle

local function WriteTags(tagName, value)
	FileHandle:write("\t\t<" .. tagName .. ">" .. value .. "</" .. tagName .. ">\n")
end

function Initialize()
	local fileName = Path:GetOutputDir() .. "/todo.xml"
	FileHandle = io.open(fileName, "w+")

	print("Exporting list to " .. fileName)

	FileHandle:write([[<?xml version="1.0" encoding="UTF-8"?>\n]])
	FileHandle:write("<todo>\n")
end

function Deinitialize()
	FileHandle:write("</todo>\n")
	io.close(FileHandle)
end

function ProcessTasks(tasks, fileName)
	FileHandle:write("\t<task fileName=" .. "\"" .. fileName .. "\">\n")

	for i, task in ipairs(tasks) do
		WriteTags("tag", task.tag)
		WriteTags("linenumber", task.lineNumber)
		WriteTags("message", task.message)
	end

	FileHandle:write("\t</task>\n")
end
