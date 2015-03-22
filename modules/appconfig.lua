local AppConfig = {}

local function LoadConfig()
	local file = loadfile(Path:GetInstallDir() .. "/config.lua")
	file()
end

function AppConfig.GetValue(configVarName)
	LoadConfig()
	return AppConfigVars[configVarName]
end

return AppConfig
