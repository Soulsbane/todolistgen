module luaaddon;

import std.file;
import std.path;

import luad.all;

import todotask;
import luastatebase;
import api.file;
import config;

class LuaAddon : LuaStateBase
{
	void processTasks(string fileName, Task[] tasks, bool lastFile)
	{
		if(hasFunction("ProcessTasks"))
		{
			lua.get!LuaFunction("ProcessTasks")(lua.newTable(tasks), fileName, lastFile);
		}
	}

	void callFunction(string name)
	{
		if(hasFunction(name))
		{
			lua.get!LuaFunction(name)();
		}
	}

	bool hasFunction(string name)
	{
		if(lua[name].isNil)
		{
			return false;
		}
		return true;
	}

	bool create(string outputFormat)
	{
		string fileName;
		foreach(DirEntry e; dirEntries(dirName(thisExePath()) ~ std.path.dirSeparator ~ "addons", "*.lua", SpanMode.breadth))
		{
			if(e.isFile)
			{
				if(outputFormat == e.name.baseName.stripExtension)
				{
					fileName = e.name;
				}
			}
		}

		if(fileName != "")
		{
			lua["FileReader"] = lua.registerType!FileReader;
			lua["FileWriter"] = lua.registerType!FileWriter;
			lua["FileUtils"] = lua.registerType!FileUtils;

			lua["Path"] = lua.registerType!Path;
			lua["Config"] = lua.registerType!LuaConfig;

			lua.doFile(fileName);
			return true;
		}

		return false;
	}
}
