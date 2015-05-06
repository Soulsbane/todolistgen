local function TestFileCopy()
	FileUtils.CopyFileToOutputDir(Path.GetAddonDir() .. "/data.txt")
end

local function TestGetLines()
	local lines = FileReader.GetLines(Path.GetAddonDir() .. "/data.txt")

	for i, line in ipairs(lines) do
		print("line: ", line)
	end
end

local function TestReadText()
	print(FileReader.ReadText(Path.GetAddonDir() .. "/data.txt"))
end

local function TestConfig()
	local fileName = FileUtils.GetDefaultTodoFileName()

	print("GetDefaultTodoFileName: ", fileName)
	print("AppConfig.GetValue: ", AppConfig.GetValue("DefaultTodoFileName"))
end

local function TestPaths()
	print("GetOutputDir:", Path.GetOutputDir())
	print("GetInstallDir:", Path.GetInstallDir())
	print("GetBaseAddonDir:", Path.GetBaseAddonDir())
	print("GetAddonDir:", Path.GetAddonDir())
	print("GetAddonModuleDir:", Path.GetAddonModuleDir())
	print("GetModuleDir:", Path.GetModuleDir())
	print("GetConfigDir:", Path.GetConfigDir())
end

local function TestRemoveFiles()
	FileUtils.RemoveFileFromAddonDir("apitestfile.lua")
	FileUtils.RemoveFileFromOutputDir("apitestfile2.lua")
end

function Initialize()
	print("Initializing...")
	TestFileCopy()
	TestGetLines()
	TestConfig()
	TestPaths()
	TestReadText()
	--TestRemoveFiles() --INFO: This is commented out since the files might not exist unless created when testing.]]
end

function Deinitialize()
	print("Deinitializing...")
end

function ProcessTasks(tasks, fileName)
end


