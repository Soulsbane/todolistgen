module config;

import std.file;

import luad.all;

class LuaConfig
{
public:
	static this()
	{
		lua_ = new LuaState;
	}

	void load(string fileName = "config.lua")
	{
		lua_.doFile(fileName);
	}

	LuaTable getTable(string name)
	{
		LuaTable variable = lua_.get!LuaTable(name);
		return variable;
	}

	T getVariable(T = string)(string name)
	{
		return lua_.get!T(name);
	}

private:
	static LuaState lua_;
}

