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
