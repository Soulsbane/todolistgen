function OnCreate()
	InputCollector.Prompt("Name", "What should your generator be called?", "Generator Name")

	if InputCollector.HasValueFor("Name") then
		if Path.AddonExists(InputCollector.GetValueFor("Name")) then
			print("That generator already exists!")
		else
			HandleAdditionalPrompts()
			CreateGeneratorDir()
			ParseTemplates()
		end
	end
end

function CreateGeneratorDir()
	local name = InputCollector.GetValueFor("Name")

	print("Creating..." .. Path.Normalize(Path.GetBaseAddonDir(), name))
	Path.EnsurePathExists(Path.Normalize(Path.GetBaseAddonDir(), name))
end

function ParseTemplates()
	local name = InputCollector.GetValueFor("Name")
	local author = InputCollector.GetValueFor("Author")
	local description = InputCollector.GetValueFor("Description")
	local templateValues = {Name = name, Author = author, Description = description}
	local tocStr = IO.LoadAndParseTemplate("generator.toc.tpl", templateValues)
	local generatorLuaStr = IO.LoadTemplate("generator.lua.tpl")
	local tocFile = IO.CreateFileInBaseAddonDir(Path.Normalize(name, name .. ".toc"))
	local luaFile = IO.CreateFileInBaseAddonDir(Path.Normalize(name, name .. ".lua"))

	tocFile:write(tocStr)
	luaFile:write(generatorLuaStr)
end

function HandleAdditionalPrompts()
	InputCollector.Prompt("Author", "What is your name(can be left blank)?", "Your Name")
	InputCollector.Prompt("Description", "Description of your generator?", "My Generator")
end

function OnDestroy()
end
