module api.file;

import std.file;
import std.path;
import std.stdio;
import std.string;
import api.path;

class FileReader
{
public:
	this() {}

	string readText(string fileName)
	{
		return .readText(fileName);
	}

	string[] getLines(string fileName)
	{
		return .readText(fileName).splitLines();
	}
}

class FileWriter
{
public:
	this() {}

	string openFile(string fileName)
	{
		string outputFile = getcwd() ~ std.path.dirSeparator ~ fileName; // FIXME: Check for custom output path.
		file_ = File(outputFile, "w+");

		return outputFile;
	}

	void write(string line)
	{
		file_.write(line);
	}

	void writeLine(string line)
	{
		file_.writeln(line);
	}

private:
	File file_;
}

class FileUtils
{
public:
	this()
	{
	}

	void copy(string from, string to)
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
}
