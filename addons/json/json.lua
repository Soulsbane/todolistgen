function Initialize()
end

function Deinitialize()
end

local FileWriter = FileWriter()

local function GetTableLength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

local function CreateOutputTable(tasks)
	local output = {}

	for i, task in ipairs(tasks) do
		if(output[task.fileName]) then
			table.insert(output[task.fileName], task)
		else
			output[task.fileName] = {}
			table.insert(output[task.fileName], task)
		end
	end
	return output
end

local function CreateJsonValue(taskTableKey)
	if taskTableKey == "lineNumber" then
		return "\t\t%q: %d"
	else
		return "\t\t%q: %q"
	end
end

function ProcessTasks(tasks, size)
	local output = CreateOutputTable(tasks)
	local fileName = FileWriter:openFile("todo.json")
	local outputSize = GetTableLength(output)
	local filesProcessed = 1

	print("Exporting list to..." .. fileName)
	FileWriter:writeLine("{")

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
	FileWriter:writeLine("}")
end
