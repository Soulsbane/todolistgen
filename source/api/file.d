module api.file;

import std.file;
import std.path;
import std.stdio;

class FileAPI
{
public:
	this() {}

	string createFile(string fileName) // TODO: Second arg will be open mode. This crashes program if arg isn't passed from lua side
	{
		string outputFile = getOutputDir() ~ "/" ~ fileName;
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
	string readText(string fileName)
	{
		return .readText(fileName);
	}

	string getOutputDir()
	{
		if(outputDir_ == "")
		{
			return getcwd();
		}
		return outputDir_;
	}

	void setOutputDir(string outputDir)
	{
		outputDir_ = outputDir;
	}

	string getInstallDir()
	{
		return dirName(thisExePath());
	}

	string getAddonDir()
	{
		return dirName(thisExePath()) ~ "/addons";
	}

	string getThisAddonDir()
	{
		import args;
		auto cmd = new CommandLineArgs;
		string outputFormat = cmd.getValue("format");

		return getAddonDir() ~ "/" ~ outputFormat;
	}

private:
	string outputDir_;
	File file_;
}
