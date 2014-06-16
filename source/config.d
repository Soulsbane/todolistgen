import std.file;
import std.stdio;

import luad.all;

struct ConfigVars
{
	string TodoTaskPattern;
	string Hello;
}

class Config
{
	auto load(string fileName = "./config.lua")
	{
		string text = readText(fileName);
		auto lua = new LuaState;

		lua.doString(text);
		auto config = lua.globals.toStruct!ConfigVars();

		return config;
	}
}
