module config;

import std.path;
import std.file;
import std.stdio;

import luaaddon.luaconfig;
import api.path;

Config _Config;

class Config : LuaConfig
{
	void load(const string fileName, const string addonName = string.init) @trusted
	{
		immutable string configPath = _AppPaths.getConfigFilesDir();
		immutable string configFile = buildNormalizedPath(configPath, fileName);

		if(!configFile.exists)
		{
			immutable string configText = import("default.config.lua");
			auto file = File(configFile, "w+");

			file.write(configText);
		}

		loadFile(configFile);
	}

	string getDefaultTodoFileName() @trusted
	{
		//TODO: Use a better name for main config table than AppConfigVars.
		return getTableVariableValue("AppConfigVars", "DefaultTodoFileName");
	}
}

static this()
{
	_Config = new Config;
}

