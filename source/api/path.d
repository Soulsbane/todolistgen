module api.path;

import std.file;
import std.path;
import std.stdio;
import std.string;

string getInstallDir()
{
	return dirName(thisExePath());
}

string getBaseAddonDir()
{
	return dirName(thisExePath()) ~ std.path.dirSeparator ~ "addons";
}

string getAddonDir()
{
	import args;
	auto cmd = new CommandLineArgs;
	string outputFormat = cmd.getValue("format");

	return getBaseAddonDir() ~ std.path.dirSeparator ~ outputFormat;
}

string getOutputDir()
{
	return getcwd();
}
