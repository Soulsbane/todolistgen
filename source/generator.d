module generator;

import std.file;
import std.path;
import std.stdio;
import std.typecons;

import api.io;
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

	void processTasks(const string fileName, TaskValues[] tasks, Flag!"isLastFile" isLastFile)
	{
		if(hasFunction("OnProcessTasks"))
		{
			callFunction("OnProcessTasks", state_.newTable(tasks), fileName, cast(bool)isLastFile);
		}
	}

	void setupAPIFunctions()
	{
		createTable("FileUtils", "Helpers", "Path", "IO", "Config", "Input");

		registerFunction("IO", "ReadText", &api.io.readText);
		registerFunction("IO", "GetLines", &api.io.getLines);
		registerFunction("IO", "CreateOutputFile", &_AppPaths.createOutputFile);
		registerFunction("IO", "CopyFileTo", &_AppPaths.copyFileTo);
		registerFunction("IO", "CopyFileToOutputDir", &_AppPaths.copyFileToOutputDir);
		registerFunction("IO", "RemoveFileFromAddonDir", &_AppPaths.removeFileFromAddonDir);
		registerFunction("IO", "RemoveFileFromOutputDir", &_AppPaths.removeFileFromOutputDir);
		registerFunction("IO", "RegisterFileForRemoval", &_AppPaths.registerFileForRemoval);

		registerFunction("Path", "GetInstallDir", &_AppPaths.getInstallDir);
		registerFunction("Path", "GetBaseAddonDir", &_AppPaths.getBaseAddonDir);
		registerFunction("Path", "GetAddonDir", &_AppPaths.getAddonDir);
		registerFunction("Path", "GetAddonDirFor", &_AppPaths.getAddonDirFor);
		registerFunction("Path", "GetAddonModuleDir", &_AppPaths.getAddonModulesDir);
		registerFunction("Path", "GetAddonTemplateDir", &_AppPaths.getAddonTemplatesDir);
		registerFunction("Path", "GetModuleDir", &_AppPaths.getModuleDir);
		registerFunction("Path", "GetOutputDir", &_AppPaths.getOutputDir);
		registerFunction("Path", "GetConfigDir", &_AppPaths.getConfigDir);
		registerFunction("Path", "GetConfigFilesDir", &_AppPaths.getConfigFilesDir);
		registerFunction("Path", "Normalize", &_AppPaths.getNormalizedPath);
		// TODO: Add EnsurePathExists API

		registerFunction("Config", "GetDefaultTodoFileName", &_Config.getDefaultTodoFileName);
		registerFunction("Config", "GetTableValue", &_Config.getTableValue);
		registerFunction("Config", "GetValue", &_Config.getValue);
		//FIXME: LuaD is returning a string instead of a LuaTable.
		//registerFunction("Config", "GetTable", &_Config.getTable);

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
		loadFile(buildNormalizedPath(_AppPaths.getModuleDir(), "helpers.lua"));
		loadFile(buildNormalizedPath(_AppPaths.getModuleDir(), "resty", "template.lua"));
		loadFile(buildNormalizedPath(_AppPaths.getModuleDir(), "etlua.lua"));
	}

	void loadConfig()
	{
		_Config.load("config.lua");
	}

private:
	InputCollector inputCollector_;
}
