module luaaddon;

import std.file;
import std.path;

import luad.all;

import api.file;
import todotask;

class LuaAddon
{
	void processTasks(Task[] tasks)
	{
		auto ProcessTasks = lua.get!LuaFunction("ProcessTasks");
		ProcessTasks(lua.newTable(tasks));
	}

	void create(string outputFormat)
	{
		string fileName;

		foreach(DirEntry e; dirEntries("addons", "*.lua", SpanMode.breadth))
		{
			if(e.isFile)
			{
				if(outputFormat == e.name.baseName.stripExtension)
				{
					fileName = e.name;
				}
			}
		}

		lua = new LuaState;
		lua.openLibs();
		lua["FileAPI"] = lua.registerType!FileAPI;
		lua.doFile(fileName);
	}
private:
	LuaState lua;
}
