module luaaddon;

import std.file;
import std.path;

import luad.all;

import todotask;
import luastatebase;
import api.file;

class LuaAddon : LuaStateBase
{
	void processTasks(Task[] tasks)
	{
		auto ProcessTasks = super.lua.get!LuaFunction("ProcessTasks");
		ProcessTasks(super.lua.newTable(tasks));
	}

	bool create(string outputFormat)
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

		if(fileName != "")
		{
			super.lua["FileAPI"] = this.lua.registerType!FileAPI;
			super.lua.doFile(fileName);
			return true;
		}

		return false;
	}
}
