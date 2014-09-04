module config;

import std.file;

import luad.all;

import luastatebase;

class LuaConfig : LuaStateBase
{
public:
	void load(string fileName = "config.lua")
	{
		super.lua.doFile(fileName);
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

