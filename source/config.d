module config;

import std.path;
import std.file;
import std.stdio;

import luaaddon.luaconfig;
import api.path;
import dtypeutils.singleton;

class Config : LuaConfig
{
	mixin MixinSingleton!Config;

	void load(const string fileName) @trusted
	{
		if(!fileName.exists)
		{
			immutable string configText = import("default.config.lua");
			auto file = File(fileName, "w+");

			file.write(configText);
		}

		loadFile(fileName);
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
