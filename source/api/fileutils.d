module api.fileutils;

import std.file;
import std.path;

import api.path;

void copyFileTo(string from, string to)
{
	std.file.copy(from, to);
}

void copyToOutputDir(string fileName)
{
	std.file.copy(fileName, getcwd() ~ std.path.dirSeparator ~ baseName(fileName));
}

void removeFileFromAddonDir(string fileName)
{
	string file = getAddonDir() ~ std.path.dirSeparator ~ fileName;

	if(exists(file))
	{
		remove(file);
	}
	else
	{
		// NOTE: Leaving this else here for now. I might make this function return a bool instead.
		//writeln("Cannot remove ", file, " file not found!");
	}
}

void removeFileFromOutputDir(string fileName)
{
	string file = getOutputDir() ~ std.path.dirSeparator ~ fileName;

	if(exists(file))
	{
		remove(file);
	}
	else
	{
		// NOTE: Leaving this else here for now. I might make this function return a bool instead.
		//writeln("Cannot remove ", file, " file not found!");
	}
}
