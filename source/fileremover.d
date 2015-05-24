module fileremover;

import std.file;
import std.path;
import std.stdio;
import std.string;

import api.path;
import config;

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

	void addFileToRemovalList(immutable string fileName) @trusted
	{

		if(!isFileInList(fileName))
		{
			immutable string baseFileRemovalName = buildNormalizedPath(getConfigDir(), "removefiles.dat");
			auto removeFilesHandle = File(baseFileRemovalName, "a+");

			removeFilesHandle.writeln(fileName);
		}
	}

	void removeFiles() @trusted
	{
		removeTodoFiles();
		removeRegisteredFiles();
	}

private:
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

	void removeTodoFiles() @trusted
	{
		auto config = new LuaConfig;
		bool deleteTodoFiles = config.getAppConfigVariable!bool("DeleteAllTodoFilesAtStart");
		string defaultTodoFileName = config.getAppConfigVariable("DefaultTodoFileName");

		if(deleteTodoFiles)
		{
			foreach (string name; dirEntries(".", SpanMode.shallow))
			{
				if(name.baseName.startsWith(defaultTodoFileName ~ "."))
				{
					remove(name);
				}
			}

		}
	}

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
