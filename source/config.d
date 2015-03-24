module config;

import std.file;
import std.path;
import std.stdio;

import luad.all;

class LuaConfig
{
public:
	this()
	{
		lua_ = new LuaState;
		lua_.setPanicHandler(&panic);
	}

	static void panic(LuaState lua, in char[] error)
	{
		import std.stdio;
		writeln("Lua parsing error!\n", error, "\n");
	}

	@trusted void load(string fileName = "config.lua")
	{
		immutable string configFile = dirName(thisExePath()) ~ std.path.dirSeparator ~ fileName;

		if(!exists(configFile))
		{
			immutable string configText = import("default.config.lua");
			auto file = File(configFile, "w+");
			file.write(configText);
		}

		lua_.doFile(configFile);
	}

	@trusted LuaTable getTable(string name)
	{
		LuaTable variable = lua_.get!LuaTable(name);
		return variable;
	}

	T getVariable(T = string)(string name)
	{
		return lua_.get!T(name);
	}
private:
	LuaState lua_;
}

