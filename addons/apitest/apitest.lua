local FileReader = FileReader()
local Path = Path()

local function TestFileCopy()
	local fileUtils = FileUtils()
	fileUtils:copyToOutputDir(Path:getAddonDir() .. "/data.txt")
end

local function TestGetLines()
	local lines

	lines = FileReader:getLines(Path:getAddonDir() .. "/data.txt")

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

local function TestPaths()
	print("^^^^", Path:getOutputDir())
	print("^^^^", Path:getInstallDir())
	print("^^^^", Path:getBaseAddonDir())
	print("^^^^", Path:getAddonDir())
	print(FileReader:readText(Path:getInstallDir() .. "/README.md"))
end

function Initialize()
	print("Initializing...")
	TestFileCopy()
	TestGetLines()
	TestConfig()
	TestPaths()
end

function Deinitialize()
	print("Deinitializing...")
end

function ProcessTasks(tasks, fileName)
end


