local File = FileAPI()

local function GetTableLength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

local function CreateOutpuTable(tasks)
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
	local output = CreateOutpuTable(tasks)
	local fileName = File:createFile("todo.json")
	local outputSizeMax
	local taskSize

	print("Exporting list to..." .. fileName)

	outputSizeMax = GetTableLength(output)
	File:writeLine("{")
	local filesProcessed = 1

	for fileName, _ in pairs(output) do
		File:writeLine(string.format("\t%q: [" , fileName))
		local closingBracketCount = 1

		for outputKey, outputValue in pairs(output[fileName]) do
			File:writeLine("\t{")
			local numEntriesCount = 1
			local numEntriesMax = #output[fileName]

			for taskTableKey, taskTableValue in pairs(outputValue) do --INFO: This loops through a task table that is stored in filename key
				if(taskTableKey ~= "fileName") then
					if(numEntriesCount == 3) then
						File:writeLine(string.format(CreateJsonValue(taskTableKey), taskTableKey, taskTableValue))
					else
						File:writeLine(string.format(CreateJsonValue(taskTableKey) ..",", taskTableKey, taskTableValue))
					end
					numEntriesCount = numEntriesCount + 1
				end
			end

			if closingBracketCount == numEntriesMax then
				File:writeLine("\t}")
			else
				File:writeLine("\t},")
			end
			closingBracketCount = closingBracketCount + 1
		end
		if filesProcessed == outputSizeMax then
			File:writeLine("\t]")
		else
			File:writeLine("\t],")
		end
		filesProcessed = filesProcessed + 1
	end
	File:writeLine("}")
end
