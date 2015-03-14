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
	void processTasks(immutable string fileName, TaskValues[] tasks, bool lastFile)
	{
		if(hasFunction("ProcessTasks"))
		{
			lua.get!LuaFunction("ProcessTasks")(lua.newTable(tasks), fileName, lastFile);
		}
	}

	void callFunction(immutable string name)
	{
		if(hasFunction(name))
		{
			lua.get!LuaFunction(name)();
		}
	}

	bool hasFunction(immutable string name)
	{
		if(lua[name].isNil)
		{
			return false;
		}
		return true;
	}

	bool create(immutable string outputFormat)
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
			lua["FileReader"] = new FileReader;
			lua["FileWriter"] = new FileWriter;
			lua["FileUtils"] = new FileUtils;

			lua["Path"] = new Path;
			lua["Config"] = new LuaConfig;

			setupPackagePaths();
			lua.doFile(fileName);

			return true;
		}

		return false;
	}

	void setupPackagePaths()
	{
		alias sep = std.path.dirSeparator;
		auto path = new Path;
		string packagePath = path.getInstallDir() ~ sep ~ "modules" ~ sep ~ "?.lua";

		packagePath ~= ";" ~ path.getAddonDir() ~ sep ~ "modules" ~ sep ~ "?.lua";
		lua["package", "path"] = packagePath;
	}
}
