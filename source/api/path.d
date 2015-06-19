module api.path;

import std.file;
import std.path;

enum string organizationName = "Raijinsoft";
enum string applicationName = "todolistgen";

import standardpaths;

string getInstallDir()
{
	return dirName(thisExePath());
}

string getBaseAddonDir()
{
	debug
	{
		return buildNormalizedPath(dirName(thisExePath()), "addons");
	}
	else
	{
		return buildNormalizedPath(getConfigDir(), "addons");
	}
}

string getAddonDir()
{
	import args;
	auto cmd = new CommandLineArgs;
	string outputFormat = cmd.getValue("format");

	// INFO: Addons are found in different locations depending on build type.
	debug
	{
		return buildNormalizedPath(getBaseAddonDir(), outputFormat);
	}
	else
	{
		return buildNormalizedPath(getConfigDir(), "addons", outputFormat);
	}
}

string getOutputDir()
{
	return getcwd();
}

string getAddonModuleDir()
{
	return buildNormalizedPath(getAddonDir(), "modules");
}

string getModuleDir()
{
	return buildNormalizedPath(getInstallDir(), "modules");
}

string getConfigDir()
{
	return buildNormalizedPath(writablePath(StandardPath.Config), organizationName, applicationName);
}

string getConfigFilesDir()
{
	return buildNormalizedPath(writablePath(StandardPath.Config), organizationName, applicationName, "config");
}

string getNormalizedPath(const(char)[][] params...)
{
	return buildNormalizedPath(params);
}
