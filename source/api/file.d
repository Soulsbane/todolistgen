module api.file;

import std.file;
import std.path;
import std.stdio;
import std.string;

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

class Path
{
public:
	this() {}

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

}
