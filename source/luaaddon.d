module luaaddon;

import std.file;
import std.path;

import luad.all;
import todotask;

class LuaAddon
{
	void processTasks(Task[] tasks)
	{
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
		lua["file"] = lua.registerType!FileAPI;
		lua.doFile(fileName);

		ProcessTasks = lua.get!LuaFunction("ProcessTasks");

	}
private:
	LuaState lua;
	LuaFunction ProcessTasks;
}

class FileAPI
{
	static string getOutputPath()
	{
		return dirName(thisExePath());
	}
}
