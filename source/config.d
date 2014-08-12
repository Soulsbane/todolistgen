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

	LuaTable getVariable(string name)
	{
		LuaTable variable = lua_.get!LuaTable(name);
		return variable;
	}

private:
	LuaState lua_;
}

