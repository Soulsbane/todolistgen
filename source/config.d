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

	void load(string fileName = "config.lua")
	{
		string configFile = dirName(thisExePath()) ~ std.path.dirSeparator ~ fileName;

		if(!exists(configFile))
		{
			string configText = import("default.config.lua");
			auto file = File(configFile, "w+");
			file.write(configText);
		}

		super.lua.doFile(configFile);
	}

	LuaTable getTable(string name)
	{
		LuaTable variable = super.lua.get!LuaTable(name);
		return variable;
	}

	T getVariable(T = string)(string name)
	{
		return super.lua.get!T(name);
	}
}

