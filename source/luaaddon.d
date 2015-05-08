module luaaddon;

import std.file;
import std.path;

import luad.all;

import todotask;
import config;

import api.path;
import api.fileutils;
import api.filereader;

@trusted:

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
		immutable string fileName = buildNormalizedPath(getAddonDir(), outputFormat) ~ ".lua";

		if(exists(fileName))
		{
			setupAPIFunctions();
			setupPackagePaths();
			loadDefaultModules();

			auto addonFile = lua_.loadFile(fileName);
			addonFile(); // INFO: We could pass arguments to the file via ... could be useful in the future.

			return true;
		}

		return false;
	}

private:
	void setupAPIFunctions()
	{
		lua_["AppConfig"] = lua_.newTable;

		lua_["FileReader"] = lua_.newTable;
		lua_["FileReader", "ReadText"] = &api.filereader.readText;
		lua_["FileReader", "GetLines"] = &api.filereader.getLines;

		lua_["FileUtils"] = lua_.newTable;
		lua_["FileUtils", "CopyFileTo"] = &api.fileutils.copyFileTo;
		lua_["FileUtils", "CopyFileToOutputDir"] = &api.fileutils.copyFileToOutputDir;
		lua_["FileUtils", "GetDefaultTodoFileName"] = &api.fileutils.getDefaultTodoFileName;
		lua_["FileUtils", "RemoveFileFromAddonDir"] = &api.fileutils.removeFileFromAddonDir;
		lua_["FileUtils", "RemoveFileFromOutputDir"] = &api.fileutils.removeFileFromOutputDir;

		lua_["Path"] = lua_.newTable;
		lua_["Path", "GetInstallDir"] = &api.path.getInstallDir;
		lua_["Path", "GetBaseAddonDir"] = &api.path.getBaseAddonDir;
		lua_["Path", "GetAddonDir"] = &api.path.getAddonDir;
		lua_["Path", "GetAddonModuleDir"] = &api.path.getAddonModuleDir;
		lua_["Path", "GetModuleDir"] = &api.path.getModuleDir;
		lua_["Path", "GetOutputDir"] = &api.path.getOutputDir;
		lua_["Path", "GetConfigDir"] = &api.path.getConfigDir;
	}

	void setupPackagePaths()
	{
		string packagePath = buildNormalizedPath(getInstallDir(), "modules", "?.lua");

		packagePath ~= ";" ~ buildNormalizedPath(getAddonDir(), "modules", "?.lua");
		lua_["package", "path"] = packagePath;
	}

	void loadDefaultModules()
	{
		auto appConfigMod = lua_.loadFile(buildNormalizedPath(getModuleDir(), "appconfig.lua"));
		auto fileUtilsMod = lua_.loadFile(buildNormalizedPath(getModuleDir(), "fileutils.lua"));

		appConfigMod();
		fileUtilsMod();
	}

private:
	LuaState lua_;
}
