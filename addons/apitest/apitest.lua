local function TestGetLines()
	local fileReader = FileReader()
	local path = Path()
	local lines

	lines = fileReader:getLines(path:getAddonDir() .. "/data.txt")

	for i, line in ipairs(lines) do
		print("line: ", line)
	end
end

function ProcessTasks(tasks, size)
	local path = Path()
	local fileReader = FileReader()

	print("^^^^", path:getInstallDir())
	print("^^^^", path:getBaseAddonDir())
	print("^^^^", path:getAddonDir())
	print(fileReader:readText(path:getInstallDir() .. "/README.md"))
	TestGetLines()
end


