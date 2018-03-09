module generator;

import std.file;
import std.path;
import std.stdio;

import api.filereader;
import api.path;
import config;
import luaaddon;
import todofilereader;
import dtermutils;

class Generator : LuaAddon
{
	bool create(const string outputFormat)
	{
		immutable string fileName = buildNormalizedPath(_AppPaths.getAddonDir(), outputFormat) ~ ".lua";

		if(fileName.exists)
		{
			loadConfig();
			setupAPIFunctions();
			setupPackagePaths();
			loadDefaultModules();

			return loadFile(fileName);
		}

		return false;
	}

	void processTasks(const string fileName, TaskValues[] tasks, const bool lastFile)
	{
		if(hasFunction("OnProcessTasks"))
		{
			callFunction("OnProcessTasks", state_.newTable(tasks), fileName, lastFile);
		}
	}

	void setupAPIFunctions()
	{
		createTable("FileUtils", /*"AppConfig",*/ "Path", "IO", "Config", "Input");

		registerFunction("IO", "ReadText", &api.filereader.readText);
		registerFunction("IO", "GetLines", &api.filereader.getLines);

		registerFunction("Path", "GetInstallDir", &_AppPaths.getInstallDir);
		registerFunction("Path", "GetBaseAddonDir", &_AppPaths.getBaseAddonDir);
		registerFunction("Path", "GetAddonDir", &_AppPaths.getAddonDir);
		registerFunction("Path", "GetAddonModuleDir", &_AppPaths.getAddonModulesDir);
		registerFunction("Path", "GetModuleDir", &_AppPaths.getModuleDir);
		registerFunction("Path", "GetOutputDir", &_AppPaths.getOutputDir);
		registerFunction("Path", "GetConfigDir", &_AppPaths.getConfigDir);
		registerFunction("Path", "GetConfigFilesDir", &_AppPaths.getConfigFilesDir);
		registerFunction("Path", "Normalize", &_AppPaths.getNormalizedPath);
		registerFunction("Path", "CopyFileTo", &_AppPaths.copyFileTo);
		registerFunction("Path", "CopyFileToOutputDir", &_AppPaths.copyFileToOutputDir);
		registerFunction("Path", "RemoveFileFromAddonDir", &_AppPaths.removeFileFromAddonDir);
		registerFunction("Path", "RemoveFileFromOutputDir", &_AppPaths.removeFileFromOutputDir);
		registerFunction("Path", "RegisterFileForRemoval", &_AppPaths.registerFileForRemoval);

		registerFunction("Config", "GetDefaultTodoFileName", &_Config.getDefaultTodoFileName);
		registerFunction("Config", "GetTableValue", &_Config.getTableValue);
		registerFunction("Config", "GetValue", &_Config.getValue);
		registerFunction("Config", "GetTable", &_Config.getTable);

		registerFunction("InputCollector", "Prompt", &inputCollector_.prompt);
		registerFunction("InputCollector", "HasValueFor", &inputCollector_.hasValueFor);
		registerFunction("InputCollector", "GetValueFor", &inputCollector_.getValueFor);
		registerFunction("InputCollector", "EnablePrompt", &inputCollector_.disablePrompt);
		registerFunction("InputCollector", "DisablePrompt", &inputCollector_.enablePrompt);
		registerFunction("InputCollector", "IsPromptEnabled", &inputCollector_.isPromptEnabled);
		registerFunction("InputCollector", "GetAllPromptValues", &inputCollector_.getAllPromptValues);

		registerFunction("Input", "ConfirmationPrompt", &confirmationPrompt);
	}

	void setupPackagePaths()
	{
		immutable string baseModulePath = buildNormalizedPath(_AppPaths.getInstallDir(), "modules");
		immutable string genModulePath = buildNormalizedPath(_AppPaths.getAddonModulesDir());

		registerPackagePaths(baseModulePath, genModulePath);
	}

	void loadDefaultModules()
	{
		/// Remove the module also.
		//loadFile(buildNormalizedPath(_AppPaths.getModuleDir(), "appconfig.lua"));
		loadFile(buildNormalizedPath(_AppPaths.getModuleDir(), "fileutils.lua"));
		loadFile(buildNormalizedPath(_AppPaths.getModuleDir(), "ansicolors.lua"));
		loadFile(buildNormalizedPath(_AppPaths.getModuleDir(), "globals.lua"));
	}

	void loadConfig()
	{
		_Config.load("config.lua");
	}

private:
	InputCollector inputCollector_;
}
