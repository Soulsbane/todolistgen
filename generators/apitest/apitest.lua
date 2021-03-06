local DataFile = Path.Normalize(Path.GetAddonDir(), "data.txt")

local function TestFileCopy()
	print("Copying data.txt to output dir...")
	Path.CopyFileToOutputDir(DataFile)
end

local function TestGetLines()
	local lines = IO.GetLines(DataFile)

	for i, line in ipairs(lines) do
		print("line: ", line)
	end
end

local function TestReadText()
	print(IO.ReadText(DataFile))
end

local function TestColors()
	IO.WriteLn("%{red}That's too bad quitting anyway!!!", " %{blue}Another sentence!", "Finally the end.")
	IO.WriteLn("%{white blink underline}Hahahahah...")
end

local function TestConfig()
	local fileName = Config.GetDefaultTodoFileName()

	print("GetDefaultTodoFileName: ", fileName)
	print("Config.GetTableValue: ", Config.GetTableValue("Config", "DefaultTodoFileName"))

	--[[	local tab = {x = 1, y = 2, z = 3}
	local vars = Config.GetTable("Config")
	print(vars)
	print(type(vars))
	for k, v in pairs(vars) do
		print(k, " => ", v)
	end]]
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
	--TestFileCopy()
	--TestGetLines()
	TestConfig()
	TestPaths()
	--TestReadText()
	--TestRemoveFiles() --INFO: This is commented out since the files might not exist unless created when testing.]]
	InputCollector.Prompt("Hello", "What is your name? ", "Gene")
	Input.ConfirmationPrompt("Are you sure you want to quit?")
end

function OnDestroy()
	print("Removing data.txt from output dir...")
	--Path.RemoveFileFromOutputDir("data.txt") --FIXME: This will sometimes cause the program to hang.
	TestColors()
end

function ProcessTasks(tasks, fileName)
end
