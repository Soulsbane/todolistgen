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

	auto getVariable(string name)
	{
		return lua_[name];
	}

private:
	LuaState lua_;
}

