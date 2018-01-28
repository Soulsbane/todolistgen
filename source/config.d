module config;

import std.path;
import std.file;
import std.stdio;

import luaaddon.luaconfig;
import api.path;

enum ORGANIZATIONNAME = "Raijinsoft";
enum APPLICATIONNAME = "todolistgen";

class Config : LuaConfig
{
	void load(const string fileName, const string addonName = string.init) @trusted
	{
		auto paths = new ApplicationPaths(addonName);
		immutable string configPath = paths.getConfigFilesDir();
		immutable string configFile = buildNormalizedPath(configPath, fileName);

		if(!configFile.exists)
		{
			immutable string configText = import("default.config.lua");
			auto file = File(configFile, "w+");

			file.write(configText);
		}

		loadFile(configFile);
	}
}

