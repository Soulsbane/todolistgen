module config;

import std.path;
import std.file;
import std.stdio;

import luaaddon.luaconfig;
import api.path;

Config _Config;

class Config : LuaConfig
{
	void load(const string fileName) @trusted
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
		return getTableVariableValue("Config", "DefaultTodoFileName");
	}

	string getTableValue(const string tableName, const string name)
	{
		return getTableVariableValue!string(tableName, name);
	}

	string getValue(const string name)
	{
		return getVariableValue!string(name);
	}
}

static this()
{
	_Config = new Config;
}

