module config;

import std.file;
import std.path;
import std.stdio;

import luad.all;
import standardpaths;

class LuaConfig
{
public:
	this(string fileName = "config.lua") @trusted
	{
		lua_ = new LuaState;
		lua_.setPanicHandler(&panic);
		load(fileName);
	}

	static void panic(LuaState lua, in char[] error) @safe
	{
		writeln("An error occured while processing config file! See below for details.\n\n", error);
	}

	LuaTable getTable(string name) @trusted
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

private:
	void load(string fileName) @trusted
	{
		immutable string organizationName = "Raijinsoft";
		immutable string applicationName = "todolistgen";
		immutable string configPath = buildNormalizedPath(writablePath(StandardPath.Config), organizationName, applicationName);
		immutable string configFile = buildNormalizedPath(writablePath(StandardPath.Config), organizationName, applicationName, fileName);

		if(!exists(configPath))
		{
			mkdirRecurse(configPath);
		}

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

