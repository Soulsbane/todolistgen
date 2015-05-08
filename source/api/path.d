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
	return buildNormalizedPath(dirName(thisExePath()), "addons");
}

string getAddonDir()
{
	import args;
	auto cmd = new CommandLineArgs;
	string outputFormat = cmd.getValue("format");

	return buildNormalizedPath(getBaseAddonDir(), outputFormat);
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

string getNormalizedPath(const(char)[][] params...)
{
	return buildNormalizedPath(params);
}
