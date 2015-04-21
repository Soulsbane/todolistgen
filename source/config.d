module config;

import std.file;
import std.path;
import std.stdio;

import luad.all;

class LuaConfig
{
public:
	this(string fileName = "config.lua")
	{
		lua_ = new LuaState;
		lua_.setPanicHandler(&panic);
		load(fileName);
	}

	static void panic(LuaState lua, in char[] error)
	{
		writeln("An error occured while processing the config file! See below for details.\n\n", error);
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

	T getAppConfigVariable(T = string)(string name)
	{
		auto value = lua_.get!T("AppConfigVars", name);
		return value;
	}

	private @trusted void load(string fileName)
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

private:
	LuaState lua_;
}

