function Initialize()
end

function Deinitialize()
end

local function TestGetLines()
	local fileReader = FileReader()
	local path = Path()
	local lines

	lines = fileReader:getLines(path:getAddonDir() .. "/data.txt")

	for i, line in ipairs(lines) do
		print("line: ", line)
	end
end

local function TestConfig()
	local config = Config()
	local patterns = config:getTable("TodoTaskPatterns")

	for k, v in pairs(patterns) do
		print(k, " = ", v)
	end
end

function ProcessTasks(tasks, fileName)
	local path = Path()
	local fileReader = FileReader()

	print("^^^^", path:getInstallDir())
	print("^^^^", path:getBaseAddonDir())
	print("^^^^", path:getAddonDir())
	print(fileReader:readText(path:getInstallDir() .. "/README.md"))
	TestGetLines()
	TestConfig()
end


