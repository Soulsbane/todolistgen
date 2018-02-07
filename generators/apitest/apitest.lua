local DataFile = Path.Normalize(Path.GetAddonDir(), "data.txt")

local function TestFileCopy()
	print("Copying data.txt to output dir...")
	Path.CopyFileToOutputDir(DataFile)
end

local function TestGetLines()
	local lines = FileReader.GetLines(DataFile)

	for i, line in ipairs(lines) do
		print("line: ", line)
	end
end

local function TestReadText()
	print(FileReader.ReadText(DataFile))
end

local function TestConfig()
	local fileName = Config.GetDefaultTodoFileName()

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
	print("Normalize:", Path.Normalize(Path.GetOutputDir(), "blah", "foo", "bar"))
end

local function TestRemoveFiles()
	FileUtils.RemoveFileFromAddonDir("apitestfile.lua")
	FileUtils.RemoveFileFromOutputDir("apitestfile2.lua")
end

function OnCreate()
	print("Initializing...")
	TestFileCopy()
	TestGetLines()
	TestConfig()
	TestPaths()
	TestReadText()
	--TestRemoveFiles() --INFO: This is commented out since the files might not exist unless created when testing.]]
end

function OnDestroy()
	print("Removing data.txt from output dir...")
	Path.RemoveFileFromOutputDir("data.txt")
end

function ProcessTasks(tasks, fileName)
end


