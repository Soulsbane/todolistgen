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
		immutable string baseFileRemovalName = buildNormalizedPath(getConfigDir(), "removefiles.dat");
		if(baseFileRemovalName.exists)
		{
			files_ = readText(baseFileRemovalName).splitLines();
		}
	}

	void addFileToRemovalList(const string fileName) @trusted
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

			if(fileToRemove.exists)
			{
				fileToRemove.remove;
			}
		}
	}

	void removeTodoFiles() @trusted
	{
		auto config = new LuaConfig;
		immutable bool deleteTodoFiles = config.getAppConfigVariable!bool("DeleteAllTodoFilesAtStart");
		immutable string defaultTodoFileName = config.getAppConfigVariable("DefaultTodoFileName");

		if(deleteTodoFiles)
		{
			foreach (string name; dirEntries(".", SpanMode.shallow))
			{
				if(name.baseName.startsWith(defaultTodoFileName ~ "."))
				{
					name.remove;
				}
			}

		}
	}

	bool isFileInList(const string fileName) @safe
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
