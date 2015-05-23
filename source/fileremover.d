module fileremover;

import std.file;
import std.path;
import std.stdio;
import std.string;

import api.path;

class FileRemover
{
	this()
	{
		string baseFileRemovalName = buildNormalizedPath(getConfigDir(), "removefiles.dat");
		if(exists(baseFileRemovalName))
		{
			files_ = readText(baseFileRemovalName).splitLines();
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

public:
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

	void addFileToRemovalList(immutable string fileName)
	{
		immutable string baseFileRemovalName = buildNormalizedPath(getConfigDir(), "removefiles.dat");
		File removeFilesHandle;

		if(exists(baseFileRemovalName))
		{
			removeFilesHandle.open(baseFileRemovalName, "a");
		}
		else
		{
			removeFilesHandle.open(baseFileRemovalName, "w+");
		}

		if(!isFileInList(fileName))
		{
			removeFilesHandle.writeln(fileName);
		}
	}

private:
	static string[] files_;
}
