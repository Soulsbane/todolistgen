module luaaddon;

import std.file;
import std.path;

import luad.all;

import todotask;
import config;

import api.file;
import api.path;
import api.fileutils;
import api.filereader;

class LuaAddon
{
public:
	this()
	{
		lua_ = new LuaState;
		lua_.openLibs();
		lua_.setPanicHandler(&panic);
	}

	static void panic(LuaState lua, in char[] error)
	{
		import std.stdio;
		writeln("Lua parsing error!\n", error, "\n");
	}

	void processTasks(immutable string fileName, TaskValues[] tasks, bool lastFile)
	{
		if(hasFunction("ProcessTasks"))
		{
			lua_.get!LuaFunction("ProcessTasks")(lua_.newTable(tasks), fileName, lastFile);
		}
	}

	void callFunction(immutable string name)
	{
		if(hasFunction(name))
		{
			lua_.get!LuaFunction(name)();
		}
	}

	bool hasFunction(immutable string name)
	{
		if(lua_[name].isNil)
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
			lua_["FileReader"] = lua_.newTable;
			lua_["FileReader", "ReadText"] = &api.filereader.readText;
			lua_["FileReader", "GetLines"] = &api.filereader.getLines;

			lua_["FileUtils"] = lua_.newTable;
			lua_["FileUtils", "CopyFileTo"] = &api.fileutils.copyFileTo;
			lua_["FileUtils", "CopyToOutputDir"] = &api.fileutils.copyToOutputDir;
			lua_["FileUtils", "RemoveFileFromAddonDir"] = &api.fileutils.removeFileFromAddonDir;
			lua_["FileUtils", "RemoveFileFromOutputDir"] = &api.fileutils.removeFileFromOutputDir;

			lua_["Config"] = new LuaConfig;

			lua_["Path"] = lua_.newTable;
			lua_["Path", "GetInstallDir"] = &api.path.getInstallDir;
			lua_["Path", "GetBaseAddonDir"] = &api.path.getBaseAddonDir;
			lua_["Path", "GetAddonDir"] = &api.path.getAddonDir;
			lua_["Path", "GetOutputDir"] = &api.path.getOutputDir;

			setupPackagePaths();
			lua_.doFile(fileName);

			return true;
		}

		return false;
	}

	void setupPackagePaths()
	{
		alias sep = std.path.dirSeparator;
		string packagePath = getInstallDir() ~ sep ~ "modules" ~ sep ~ "?.lua";

		packagePath ~= ";" ~ getAddonDir() ~ sep ~ "modules" ~ sep ~ "?.lua";
		lua_["package", "path"] = packagePath;
	}

private:
	LuaState lua_;
}
