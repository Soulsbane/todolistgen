function OnCreate()
	InputCollector.Prompt("Name", "What should your generator be called?", "Generator Name")

	if InputCollector.HasValueFor("Name") then
		if Path.AddonExists(InputCollector.GetValueFor("Name")) then
			IO.WriteLn("%{red}That generator already exists!")
		else
			HandleAdditionalPrompts()
			CreateGeneratorDir()
			ParseTemplates()
			ConfirmCreation()
		end
	end
end

function ConfirmCreation()
	local name = InputCollector.GetValueFor("Name")

	if Path.AddonExists(name) then
		print("Created new generator in " .. Path.Normalize(Path.GetBaseAddonDir(), name))
	else
		IO.WriteLn("{red}Failed to create generator!")
	end
end

function CreateGeneratorDir()
	local name = InputCollector.GetValueFor("Name")
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
