local FileWriter = FileWriter()

function Initialize()
	local fileName = FileWriter:openFile("todo.json")

	print("Exporting list to..." .. fileName)
	FileWriter:writeLine("{")
end

function Deinitialize()
	FileWriter:writeLine("}")
end

local function CreateJsonValue(taskTableKey)
	if taskTableKey == "lineNumber" then
		return "\t\t%q: %d"
	else
		return "\t\t%q: %q"
	end
end

function ProcessTasks(tasks, fileName)
	local outputSize = GetTableLength(output)
	local filesProcessed = 1

	for fileName, _ in pairs(output) do
		local closingBracketCount = 1

		FileWriter:writeLine(string.format("\t%q: [" , fileName))

		for outputKey, outputValue in pairs(output[fileName]) do
			local numEntriesCount = 1
			local numEntriesMax = #output[fileName]

			FileWriter:writeLine("\t{")

			for taskTableKey, taskTableValue in pairs(outputValue) do --INFO: This loops through a task table that is stored in filename key
				if(taskTableKey ~= "fileName") then
					if(numEntriesCount == 3) then
						FileWriter:writeLine(string.format(CreateJsonValue(taskTableKey), taskTableKey, taskTableValue))
					else
						FileWriter:writeLine(string.format(CreateJsonValue(taskTableKey) ..",", taskTableKey, taskTableValue))
					end
					numEntriesCount = numEntriesCount + 1
				end
			end

			if closingBracketCount == numEntriesMax then
				FileWriter:writeLine("\t}")
			else
				FileWriter:writeLine("\t},")
			end
			closingBracketCount = closingBracketCount + 1
		end
		if filesProcessed == outputSize then
			FileWriter:writeLine("\t]")
		else
			FileWriter:writeLine("\t],")
		end
		filesProcessed = filesProcessed + 1
	end
end
