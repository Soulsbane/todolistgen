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
		auto ProcessTasks = lua_.get!LuaFunction("ProcessTasks");
		ProcessTasks(lua_.newTable(tasks));
	}

	void create(string outputFormat)
	{
		string fileName;

		foreach(DirEntry e; dirEntries("addons", "*.lua_", SpanMode.breadth))
		{
			if(e.isFile)
			{
				if(outputFormat == e.name.baseName.stripExtension)
				{
					fileName = e.name;
				}
			}
		}

		lua_ = new LuaState;
		lua_.openLibs();
		lua_["FileAPI"] = lua_.registerType!FileAPI;
		lua_.doFile(fileName);
	}
private:
	LuaState lua_;
}
