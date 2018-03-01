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
		paths_ = new ApplicationPaths(outputFormat);
		immutable string fileName = buildNormalizedPath(paths_.getAddonDir(), outputFormat) ~ ".lua";

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
		createTable("FileUtils", "AppConfig", "Path", "IO", "Config", "Input");

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

		registerFunction("Config", "GetDefaultTodoFileName", &config_.getDefaultTodoFileName);

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
		immutable string baseModulePath = buildNormalizedPath(paths_.getInstallDir(), "modules");
		immutable string genModulePath = buildNormalizedPath(paths_.getAddonModulesDir());

		registerPackagePaths(baseModulePath, genModulePath);
	}

	void loadDefaultModules()
	{
		loadFile(buildNormalizedPath(paths_.getModuleDir(), "appconfig.lua"));
		loadFile(buildNormalizedPath(paths_.getModuleDir(), "fileutils.lua"));
	}

	void loadConfig()
	{
		config_ = new Config;
		config_.load("config.lua");
	}

private:
	ApplicationPaths paths_;
	Config config_;
	InputCollector inputCollector_;
}
