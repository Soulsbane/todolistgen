module generator;

import std.file;
import std.path;
import std.stdio;

//import api.fileutils; //FIXME: Needs ported to new path class and needs dfileutils.FileRemover.
import api.filereader;
import api.path;
import config;
import luaaddon;
import todofilereader;

class Generator : LuaAddon
{
	bool create(const string outputFormat)
	{
		paths_ = new ApplicationPaths(outputFormat);
		immutable string fileName = buildNormalizedPath(paths_.getAddonDir(), outputFormat) ~ ".lua";

		if(fileName.exists)
		{
			setupAPIFunctions();
			setupPackagePaths();
			loadDefaultModules();

			return loadFile(fileName);
		}

		return false;
	}

	void processTasks(const string fileName, TaskValues[] tasks, bool lastFile)
	{
		if(hasFunction("ProcessTasks"))
		{
			callFunction("ProcessTasks", state_.newTable(tasks), fileName, lastFile);
		}
	}

	void setupAPIFunctions()
	{
		createTable("FileUtils", "FileReader", "AppConfig", "Path", "IO", "Config");

		registerFunction("FileReader", "ReadText", &api.filereader.readText); /// FIXME: Deprecated use IO Instead.
		registerFunction("FileReader", "GetLines", &api.filereader.getLines); /// FIXME: Deprecated use IO Instead.

		//registerFunction("Config", "GetDefaultTodoFileName"] = &api.fileutils.getDefaultTodoFileName);

		registerFunction("IO", "ReadText", &api.filereader.readText);
		registerFunction("IO", "GetLines", &api.filereader.getLines);

		registerFunction("Path", "GetInstallDir", &paths_.getInstallDir);
		registerFunction("Path", "GetBaseAddonDir", &paths_.getBaseAddonDir);
		registerFunction("Path", "GetAddonDir", &paths_.getAddonDir);
		registerFunction("Path", "GetAddonModuleDir", &paths_.getAddonModulesDir);
		registerFunction("Path", "GetModuleDir", &paths_.getModuleDir);
		registerFunction("Path", "GetOutputDir", &paths_.getOutputDir);
		registerFunction("Path", "GetConfigDir", &paths_.getConfigDir);
		registerFunction("Path", "GetConfigFilesDir", &paths_.getConfigFilesDir);
		registerFunction("Path", "Normalize", &paths_.getNormalizedPath);
		registerFunction("Path", "CopyFileTo", &paths_.copyFileTo);
		registerFunction("Path", "CopyFileToOutputDir", &paths_.copyFileToOutputDir);
		registerFunction("Path", "RemoveFileFromAddonDir", &paths_.removeFileFromAddonDir);
		registerFunction("Path", "RemoveFileFromOutputDir", &paths_.removeFileFromOutputDir);
		registerFunction("Path", "RegisterFileForRemoval", &paths_.registerFileForRemoval);
	}

	void setupPackagePaths()
	{
		immutable string baseModulePath = buildNormalizedPath(paths_.getInstallDir(), "modules");
		immutable string genModulePath = buildNormalizedPath(paths_.getAddonModulesDir());

		registerPackagePaths(baseModulePath, genModulePath);
	}

	void loadDefaultModules()
	{
		loadFile(buildNormalizedPath(paths_.getModuleDir(), "appconfig.lua"));
		loadFile(buildNormalizedPath(paths_.getModuleDir(), "fileutils.lua"));
	}

private:
	ApplicationPaths paths_;
}
