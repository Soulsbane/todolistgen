import std.stdio;
import std.string;
import std.file;
import std.path;
import std.range;
import std.algorithm;
import std.getopt;

static import std.parallelism;

import todofilereader;
import todotask;
import luaaddon;
import args;
import config;

void removeTodoFiles()
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

void processFile(immutable string fileName, immutable string outputFormat)
{
	if(exists(fileName))
	{
		auto reader = new TodoFileReader;
		auto addon = new LuaAddon;
		auto tasks = reader.readFile(fileName);
		immutable bool created = addon.create(outputFormat);

		if(created)
		{
			writeln("Processing ", fileName);

			addon.callFunction("Initialize");
			addon.processTasks(fileName, tasks, true);
			addon.callFunction("Deinitialize");
		}
		else
		{
			writeln(outputFormat, " output format not found!");
		}
	}
	else
	{
		writeln("Failed to open ", fileName, ". File not found!");
	}
}

void processDir(immutable string dir, immutable string outputFormat, immutable string pattern)
{
	auto reader = new TodoFileReader;
	TaskValues[][string] files;
	uint numFiles = 0;
	auto filesWalk = dirEntries(dir, pattern, SpanMode.breadth);

	auto addon = new LuaAddon;
	immutable bool created = addon.create(outputFormat);

	if(created)
	{
		writeln("Processing ", walkLength(filesWalk), " files...");
		addon.callFunction("Initialize");

		foreach(DirEntry e; std.parallelism.parallel(dirEntries(dir, pattern, SpanMode.breadth)))
		{
			if(e.isFile)
			{
				auto name = buildNormalizedPath(e.name);

				if(!name.startsWith(".")) // TODO: Find a better way to represent hidden files
				{
					TaskValues[] tasks = reader.readFile(name);

					write("\x1B[2K");
					write("\r");
					write(name);

					if(tasks.length > 0)
					{
						files[name] ~= tasks;
					}
				}
			}
		}

		write("\x1B[2K");
		write("\n");

		foreach(fileName; sort(files.keys))
		{
			numFiles++;

			if(numFiles == files.length)
			{
				addon.processTasks(fileName, files[fileName], true);
			}
			else
			{
				addon.processTasks(fileName, files[fileName], false);
			}
		}

		addon.callFunction("Deinitialize");
	}
	else
	{
		writeln(outputFormat, " output format not found!");
	}
}

void handleGetOpt(string[] args)
{
	string dir = ".";
	string outputFormat = "stdout";
	string pattern = "*.*";

	//getopt(args, "dir", &dir, "format", &outputFormat, "pattern", &pattern);

	//writeln("dir = ", dir, " format = ", outputFormat, " pattern = ", pattern);

	/*foreach(value; args)
	{
		writeln(value, " Length = ", args.length);
	}*/

	if(args.length > 1)
	{
		//writeln("Args1 = ", args[1], " Length = ", args.length);
		string value = args[1];

		if(value.startsWith("--dir")  || value.startsWith("--format") || value.startsWith("--pattern"))
		{
			getopt(args, "dir", &dir, "format", &outputFormat, "pattern", &pattern);

			//writeln("Only passed args dir =  ", dir, " format = ", outputFormat, " pattern = ", pattern);
		}
		else
		{
			getopt(args, "dir", &dir, "format", &outputFormat, "pattern", &pattern);
			//writeln("Passed a filename dir = ", dir, " format = ", outputFormat, " pattern = ", pattern);
			//writeln("Passed a filename ", value);
		}
	}
}

void handleArguments(string[] args)
{
	auto cmd = new CommandLineArgs(args);
	immutable string dir = cmd.getValue("dir");
	immutable string outputFormat = cmd.getValue("format");
	immutable string pattern = cmd.getValue("pattern");

	if(cmd.isValidValue("filename"))
	{
		immutable string fileName = cmd.getValue("filename");
		processFile(fileName, outputFormat);
	}
	else
	{
		processDir(dir, outputFormat, pattern);
	}
}

void main(string[] args)
{
	removeTodoFiles();
	//handleArguments(args);
	handleGetOpt(args);
}
