function OnCreate()
	HandlePrompts()
end

function CreateGeneratorDir()
	if InputCollector.HasValueFor("Name") then
	end
end

function HandlePrompts()
	InputCollector.Prompt("Author", "What is your name(can be left blank)?", "Your Name")
	InputCollector.Prompt("Name", "What should your generator be called?", "Generator Name")
	InputCollector.Prompt("Description", "Description of your generator?", "My Generator")
end

function OnDestroy()
end
