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

class FileUtils
{
public:
	this()
	{
		path_ = new Path;
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
		string file = path_.getAddonDir() ~ std.path.dirSeparator ~ fileName;

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
		string file = path_.getOutputDir() ~ std.path.dirSeparator ~ fileName;

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

private:
	Path path_;
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

	string getOutputDir()
	{
		return getcwd();
	}

}
