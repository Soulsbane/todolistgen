local AppConfig = {}

local function LoadConfig()
	local file = loadfile(Path:GetInstallDir() .. "/config.lua")
	file()
end

function AppConfig.GetValue(configVarName)
	LoadConfig()
	--print("is shit here: ", AppConfigVars.TodoFileName)
	return AppConfigVars[configVarName]
end

return AppConfig
