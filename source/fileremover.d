module fileremover;

import std.file;
import std.path;
import std.stdio;
import std.string;

import api.path;

class FileRemover
{
public:
	this()
	{
		string baseFileRemovalName = buildNormalizedPath(getConfigDir(), "removefiles.dat");
		if(exists(baseFileRemovalName))
		{
			files_ = readText(baseFileRemovalName).splitLines();
		}
	}

	void removeRegisteredFiles() @trusted
	{
		foreach(file; files_)
		{
			immutable string fileToRemove = buildNormalizedPath(getOutputDir(), file);

			if(exists(fileToRemove))
			{
				remove(fileToRemove);
			}
		}
	}

	void addFileToRemovalList(immutable string fileName) @trusted
	{

		if(!isFileInList(fileName))
		{
			immutable string baseFileRemovalName = buildNormalizedPath(getConfigDir(), "removefiles.dat");
			auto removeFilesHandle = File(baseFileRemovalName, "a+");

			removeFilesHandle.writeln(fileName);
		}
	}

private:
	bool isFileInList(immutable string fileName) @safe
	{
		bool found = false;

		foreach(file; files_)
		{
			if(file == fileName)
			{
				found = true;
				break;
			}
		}
		return found;
	}

private:
	static string[] files_;
}
