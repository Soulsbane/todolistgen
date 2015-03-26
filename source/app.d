import std.stdio;
import std.string;
import std.file;
import std.path;
import std.range;
import std.algorithm;

static import std.parallelism;

import todofilereader;
import todotask;
import luaaddon;
import args;

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
	int numFiles = 0;
	auto filesWalk = dirEntries(dir, pattern, SpanMode.breadth);

	auto addon = new LuaAddon;
	immutable bool created = addon.create(outputFormat);

	if(created)
	{
		addon.callFunction("Initialize");
		writeln("Processing ", walkLength(filesWalk), " files...");

		foreach(DirEntry e; std.parallelism.parallel(dirEntries(dir, pattern, SpanMode.breadth)))
		{
			if(e.isFile)
			{
				auto name = buildNormalizedPath(e.name);

				if(!name.startsWith("."))
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
	handleArguments(args);
}
