module config;

import std.file;

import luad.all;

class LuaConfig
{
public:
	void load(string fileName = "config.lua")
	{
		lua_ = new LuaState;
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

