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
			auto ProcessTasks = super.lua.get!LuaFunction("ProcessTasks");
			ProcessTasks(super.lua.newTable(tasks), fileName, lastFile);
		}
	}

	void callFunction(string name)
	{
		if(hasFunction(name))
		{
			auto TempFunction = super.lua.get!LuaFunction(name);
			TempFunction();
		}
	}

	bool hasFunction(string name)
	{
		if(super.lua[name].isNil)
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
			super.lua["FileReader"] = this.lua.registerType!FileReader;
			super.lua["FileWriter"] = this.lua.registerType!FileWriter;
			super.lua["Path"] = this.lua.registerType!Path;
			super.lua["Config"] = this.lua.registerType!LuaConfig;
			super.lua.doFile(fileName);
			return true;
		}

		return false;
	}
}
