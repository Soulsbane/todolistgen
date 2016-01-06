module config;

import std.file;
import std.path;
import std.stdio;

import luad.all;
import standardpaths;
import api.path;

class LuaConfig
{
public:
	this(string fileName = "config.lua") @trusted
	{
		lua_ = new LuaState;
		lua_.setPanicHandler(&panic);
		load(fileName);
	}

	static void panic(LuaState lua, in char[] error) @trusted
	{
		writeln("An error occured while processing config file! See below for details.\n\n", error);
	}

	LuaTable getTable(const string name) @trusted
	{
		LuaTable variable = lua_.get!LuaTable(name);
		return variable;
	}

	T getVariable(T = string)(string name)
	{
		return lua_.get!T(name);
	}

	T getAppConfigVariable(T = string)(const string name)
	{
		auto value = lua_.get!T("AppConfigVars", name);
		return value;
	}

private:
	void load(const string fileName) @trusted
	{
		immutable string configPath = getConfigFilesDir();
		immutable string configFile = buildNormalizedPath(configPath, fileName);

		if(!configFile.exists)
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

