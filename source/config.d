module config;

import std.file;
import std.path;
import std.stdio;

import luad.all;

import luastatebase;

class LuaConfig : LuaStateBase
{
public:
	this() {}

	@trusted void load(string fileName = "config.lua")
	{
		immutable string configFile = dirName(thisExePath()) ~ std.path.dirSeparator ~ fileName;

		if(!exists(configFile))
		{
			immutable string configText = import("default.config.lua");
			auto file = File(configFile, "w+");
			file.write(configText);
		}

		lua.doFile(configFile);
	}

	@trusted LuaTable getTable(string name)
	{
		LuaTable variable = lua.get!LuaTable(name);
		return variable;
	}

	T getVariable(T = string)(string name)
	{
		return lua.get!T(name);
	}
}

