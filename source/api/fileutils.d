module api.fileutils;

import std.file;
import std.path;

import api.path;
import config;

void copyFileTo(string from, string to)
{
	std.file.copy(from, to, PreserveAttributes.yes);
}

void copyToOutputDir(string fileName)
{
	std.file.copy(fileName, getcwd() ~ std.path.dirSeparator ~ baseName(fileName), PreserveAttributes.yes);
}

bool removeFileFromAddonDir(string fileName)
{
	string file = getAddonDir() ~ std.path.dirSeparator ~ fileName;

	if(exists(file))
	{
		remove(file);
		return true;
	}
	else
	{
		return false;
	}
}

bool removeFileFromOutputDir(string fileName)
{
	string file = getOutputDir() ~ std.path.dirSeparator ~ fileName;

	if(exists(file))
	{
		remove(file);
		return true;
	}
	else
	{
		return false;
	}
}

string getDefaultTodoFileName()
{
	auto config = new LuaConfig;
	string value = config.getAppConfigVariable("DefaultTodoFileName");

	return value;
}
