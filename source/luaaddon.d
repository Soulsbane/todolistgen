module luaaddon;

import std.file;
import std.path;
import std.stdio;

import luad.all;
import todotask;

class LuaAddon
{
	void processTasks(Task[] tasks)
	{
		auto ProcessTasks = lua.get!LuaFunction("ProcessTasks");
		ProcessTasks(lua.newTable(tasks));
	}

	void create(string outputFormat)
	{
		string fileName;

		foreach(DirEntry e; dirEntries("addons", "*.lua", SpanMode.breadth))
		{
			if(e.isFile)
			{
				if(outputFormat == e.name.baseName.stripExtension)
				{
					fileName = e.name;
				}
			}
		}

		lua = new LuaState;
		lua.openLibs();
		lua["FileAPI"] = lua.registerType!FileAPI;
		lua.doFile(fileName);
	}
private:
	LuaState lua;
}

class FileAPI
{
public:
	this() {}

	void createFile(string fileName) // TODO: Second arg will be open mode. This crashes program if arg isn't passed from lua side
	{
		file_ = File(getOutputPath() ~ "/" ~ fileName, "w+"); // TODO: Return the path with filename as string
	}

	void writeLine(string line)
	{
		file_.writeln(line);
	}

	string getOutputPath()
	{
		if(outputPath_ == "")
		{
			return dirName(thisExePath());
		}
		return outputPath_;
	}

	void setOutputPath(string outputPath)
	{
		outputPath_ = outputPath;
	}

private:
	string outputPath_;
	File file_;
}
