module api.fileutils;

import std.file;
import std.path;

import api.path;
import config;

alias sep = std.path.dirSeparator;

void copyFileTo(string from, string to)
{
	std.file.copy(from, to, PreserveAttributes.yes);
}

void copyToOutputDir(string fileName)
{
	std.file.copy(fileName, getcwd() ~ sep ~ baseName(fileName), PreserveAttributes.yes);
}

void removeFileFromAddonDir(string fileName)
{
	string file = getAddonDir() ~ sep ~ fileName;

	if(exists(file))
	{
		remove(file);
	}
}

void removeFileFromOutputDir(string fileName)
{
	string file = getOutputDir() ~ sep ~ fileName;

	if(exists(file))
	{
		remove(file);
	}
}

string getDefaultTodoFileName()
{
	auto config = new LuaConfig;
	string value = config.getAppConfigVariable("DefaultTodoFileName");

	return value;
}
