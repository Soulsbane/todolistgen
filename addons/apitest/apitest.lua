local function TestFileCopy()
	FileUtils:copyToOutputDir(Path:getAddonDir() .. "/data.txt")
end

local function TestGetLines()
	local lines = FileReader:getLines(Path:getAddonDir() .. "/data.txt")

	for i, line in ipairs(lines) do
		print("line: ", line)
	end
end

local function TestConfig()
	local patterns = Config:getTable("TodoTaskPatterns")

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

local function TestRemoveFiles()
	FileUtils:removeFileFromAddonDir("apitestfile.lua")
	FileUtils:removeFileFromOutputDir("apitestfile2.lua")
end

function Initialize()
	print("Initializing...")
	TestFileCopy()
	TestGetLines()
	TestConfig()
	TestPaths()
	TestRemoveFiles() --INFO: This is commented out since the files might not exist unless created when testing.]]
	TestWriteToFiles()
end

function Deinitialize()
	print("Deinitializing...")
end

function ProcessTasks(tasks, fileName)
end


