module luaaddon;

import std.file;
import std.path;

import luad.all;

import todotask;
import luastatebase;
import config;

import api.file;
import api.path;
import api.fileutils;
import api.filereader;


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
			lua["FileReader"] = lua.newTable;
			lua["FileReader", "ReadText"] = &api.filereader.readText;
			lua["FileReader", "GetLines"] = &api.filereader.getLines;

			lua["FileUtils"] = lua.newTable;
			lua["FileUtils", "CopyFileTo"] = &api.fileutils.copyFileTo;
			lua["FileUtils", "CopyToOutputDir"] = &api.fileutils.copyToOutputDir;
			lua["FileUtils", "RemoveFileFromAddonDir"] = &api.fileutils.removeFileFromAddonDir;
			lua["FileUtils", "RemoveFileFromOutputDir"] = &api.fileutils.removeFileFromOutputDir;

			lua["Config"] = new LuaConfig;

			lua["Path"] = lua.newTable;
			lua["Path", "GetInstallDir"] = &api.path.getInstallDir;
			lua["Path", "GetBaseAddonDir"] = &api.path.getBaseAddonDir;
			lua["Path", "GetAddonDir"] = &api.path.getAddonDir;
			lua["Path", "GetOutputDir"] = &api.path.getOutputDir;

			setupPackagePaths();
			lua.doFile(fileName);

			return true;
		}

		return false;
	}

	void setupPackagePaths()
	{
		alias sep = std.path.dirSeparator;
		string packagePath = getInstallDir() ~ sep ~ "modules" ~ sep ~ "?.lua";

		packagePath ~= ";" ~ getAddonDir() ~ sep ~ "modules" ~ sep ~ "?.lua";
		lua["package", "path"] = packagePath;
	}
}
