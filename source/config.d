module config;

import std.file;

import luad.all;

struct ConfigVars
{
	string TodoTaskPattern;
}

struct Config
{
	auto load(string fileName = "./config.lua")
	{
		string text = readText(fileName);
		auto lua = new LuaState;

		lua.doString(text);
		vars = lua.globals.toStruct!ConfigVars();

		return vars;
	}
private:
	static ConfigVars vars;
}

class LuaConfig
{
public:
	void load(string fileName = "./config.lua")
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

