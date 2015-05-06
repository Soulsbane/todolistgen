module api.path;

import std.file;
import std.path;
import std.stdio;
import std.string;

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
	immutable string organizationName = "Raijinsoft";
	immutable string applicationName = "todolistgen";

	return buildNormalizedPath(writablePath(StandardPath.Config), organizationName, applicationName);
}
