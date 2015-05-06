module api.fileutils;

import std.file;
import std.path;

import api.path;
import config;

void copyFileTo(string from, string to) @trusted
{
	std.file.copy(from, to, PreserveAttributes.yes);
}

void copyToOutputDir(string fileName) @trusted
{
	std.file.copy(fileName, buildNormalizedPath(getcwd(), baseName(fileName)), PreserveAttributes.yes);
}

void removeFileFromAddonDir(string fileName) @trusted
{
	string file = buildNormalizedPath(getAddonDir(), fileName);

	if(exists(file))
	{
		remove(file);
	}
}

void removeFileFromOutputDir(string fileName) @trusted
{
	string file = buildNormalizedPath(getOutputDir(), fileName);

	if(exists(file))
	{
		remove(file);
	}
}

string getDefaultTodoFileName() @trusted
{
	auto config = new LuaConfig;
	string value = config.getAppConfigVariable("DefaultTodoFileName");

	return value;
}
