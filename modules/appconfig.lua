local AppConfig = AppConfig

local function LoadConfig()
	print("LOADCONFIG", Path.Normalize(Path:GetConfigFilesDir(), "config.lua"))
	local file = loadfile(Path.Normalize(Path:GetConfigFilesDir(), "config.lua"))
	file()
end

function AppConfig.GetValue(configVarName)
	LoadConfig()
	return Config[configVarName]
end

return AppConfig
