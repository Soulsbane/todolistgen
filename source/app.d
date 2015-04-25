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

void processFile(immutable string fileName, immutable string outputFormat) @trusted
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

void processDir(immutable string dir, immutable string outputFormat, immutable string pattern) @trusted
{
	auto reader = new TodoFileReader;
	TaskValues[][string] files;
	uint filesCounter = 0;
	auto numFilesToProcess = dirEntries(dir, pattern, SpanMode.breadth);

	auto addon = new LuaAddon;
	immutable bool created = addon.create(outputFormat);

	if(created)
	{
		writeln("Processing ", walkLength(numFilesToProcess), " files...");
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
			filesCounter++;

			if(filesCounter == files.length)
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

void handleArguments(string[] args) @trusted
{
	auto cmd = new CommandLineArgs(args);

	if(args.length > 1)
	{
		string value = args[1];

		if(value.startsWith("--dir")  || value.startsWith("--format") || value.startsWith("--pattern"))
		{
			processDir(cmd.getValue("dir"), cmd.getValue("format"), cmd.getValue("pattern"));
		}
		else
		{
			if(!value.startsWith("--help"))
			{
				processFile(value, cmd.getValue("format"));
			}
		}
	}
	else
	{
		processDir(cmd.getValue("dir"), cmd.getValue("format"), cmd.getValue("pattern"));
	}
}

void main(string[] args)
{
	removeTodoFiles();
	handleArguments(args);
}
