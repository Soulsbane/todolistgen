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
import dpathutils.exists;

class Generator : LuaAddon
{
	bool create(const string outputFormat)
	{
		paths_ = ApplicationPaths.getInstance();
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

	void processTasks(const string fileName, TaskValues[] tasks, Flag!"isLastFile" isLastFile)
	{
		if(hasFunction("OnProcessTasks"))
		{
			callFunction("OnProcessTasks", state_.newTable(tasks), fileName, cast(bool)isLastFile);
		}
	}

	void setupAPIFunctions()
	{
		createTable("FileUtils", "Path", "IO", "Config", "Input", "Date", "Time", "DateTime");

		registerFunction("IO", "ReadText", &api.io.readText);
		registerFunction("IO", "GetLines", &api.io.getLines);
		registerFunction("IO", "CreateOutputFile", &paths_.createOutputFile);
		registerFunction("IO", "CopyFileTo", &paths_.copyFileTo);
		registerFunction("IO", "CopyFileToOutputDir", &paths_.copyFileToOutputDir);
		registerFunction("IO", "RemoveFileFromAddonDir", &paths_.removeFileFromAddonDir);
		registerFunction("IO", "RemoveFileFromOutputDir", &paths_.removeFileFromOutputDir);
		registerFunction("IO", "RegisterFileForRemoval", &paths_.registerFileForRemoval);

		registerFunction("Path", "GetInstallDir", &paths_.getInstallDir);
		registerFunction("Path", "GetBaseAddonDir", &paths_.getBaseAddonDir);
		registerFunction("Path", "GetAddonDir", &paths_.getAddonDir);
		registerFunction("Path", "GetAddonDirFor", &paths_.getAddonDirFor);
		registerFunction("Path", "GetAddonModuleDir", &paths_.getAddonModulesDir);
		registerFunction("Path", "GetAddonTemplateDir", &paths_.getAddonTemplatesDir);
		registerFunction("Path", "GetModuleDir", &paths_.getModuleDir);
		registerFunction("Path", "GetOutputDir", &paths_.getOutputDir);
		registerFunction("Path", "GetConfigDir", &paths_.getConfigDir);
		registerFunction("Path", "GetConfigFilesDir", &paths_.getConfigFilesDir);
		registerFunction("Path", "Normalize", &paths_.getNormalizedPath);
		registerFunction("Path", "CreateDirInGeneratorDir", &paths_.createDirInGeneratorDir);
		registerFunction("Path", "EnsurePathExists", &dpathutils.exists.ensurePathExists);
		registerFunction("Path", "Exists", &paths_.dirExists);
		registerFunction("Path", "AddonExists", &paths_.addonExists);

		registerFunction("Config", "GetDefaultTodoFileName", &config_.getDefaultTodoFileName);
		registerFunction("Config", "GetTableValue", &config_.getTableValue);
		registerFunction("Config", "GetValue", &config_.getValue);
		//FIXME: LuaD is returning a string instead of a LuaTable.
		//registerFunction("Config", "GetTable", &config_.getTable);

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
		loadFile(buildNormalizedPath(paths_.getModuleDir(), "ansicolors.lua"));
		loadFile(buildNormalizedPath(paths_.getModuleDir(), "globals.lua"));
		loadFile(buildNormalizedPath(paths_.getModuleDir(), "io.lua"));
		loadFile(buildNormalizedPath(paths_.getModuleDir(), "resty", "template.lua"));
	}

	void loadConfig()
	{
		immutable string configPath = paths_.getConfigFilesDir();
		immutable string configFile = buildNormalizedPath(configPath, "config.lua");

		config_ = Config.getInstance();
		config_.load(configFile);
	}

		override string getAuthor()
		{
			return string.init;
		}

		override string getName()
		{
			return string.init;
		}

		override size_t getVersion()
		{
			return 1_000;
		}

		override string getDescription()
		{
			return string.init;
		}

private:
	InputCollector inputCollector_;
	Config config_;
	ApplicationPaths paths_;
}
