local AppConfig = AppConfig

local function LoadConfig()
	local file = loadfile(Path:GetConfigDir() .. "/config.lua") --FIXME: Broken due to config dir changes.
	file()
end

function AppConfig.GetValue(configVarName)
	LoadConfig()
	return AppConfigVars[configVarName]
end

return AppConfig
