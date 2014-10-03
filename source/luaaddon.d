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
	void processTasks(Task[] tasks)
	{
		import std.conv;
		import std.stdio;

		auto ProcessTasks = super.lua.get!LuaFunction("ProcessTasks");
		ProcessTasks(super.lua.newTable(tasks), tasks.length);
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
