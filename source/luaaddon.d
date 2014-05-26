module luaaddon;

import std.stdio;
import std.string;
import std.file;
import std.path;

import luad.all;
import todotask;

class LuaAddon
{
	this(string fileName)
	{
		lua = new LuaState;
		lua.openLibs();
		lua.doFile(fileName);
	}

	void processTasks(Task[] tasks)
	{
		auto ProcessTasks = lua.get!LuaFunction("ProcessTasks"); // TODO: Move the intialization to constructor?
		ProcessTasks(lua.newTable(tasks));
	}
private:
	LuaState lua;
}

LuaAddon createAddon(string outputFormat)
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
	return new LuaAddon(fileName);
}
