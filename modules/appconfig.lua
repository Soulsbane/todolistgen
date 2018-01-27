local AppConfig = AppConfig

local function LoadConfig()
	local file = loadfile(Path.Normalize(Path:GetConfigDir(), "config.lua"))
	file()
end

function AppConfig.GetValue(configVarName)
	LoadConfig()
	return AppConfigVars[configVarName]
end

return AppConfig
