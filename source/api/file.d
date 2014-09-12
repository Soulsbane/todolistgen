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
		string outputFile = getOutputPath() ~ "/" ~ fileName;
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

	string getOutputPath()
	{
		if(outputPath_ == "")
		{
			return getcwd();
		}
		return outputPath_;
	}

	void setOutputPath(string outputPath)
	{
		outputPath_ = outputPath;
	}

	string getInstallDir()
	{
		return dirName(thisExePath());
	}

	string getAddonDir()
	{
		return dirName(thisExePath()) ~ "/addons";
	}

private:
	string outputPath_;
	File file_;
}
