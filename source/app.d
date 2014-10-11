import std.stdio;
import std.string;
import std.file;
import std.path;
static import std.parallelism;

import todofilereader;
import todotask;
import luaaddon;
import args;

void processFile(string fileName, string outputFormat )
{
	if(exists(fileName))
	{
		auto reader = new TodoFileReader;
		auto addon = new LuaAddon;
		auto tasks = reader.readFile(fileName);
		bool created;

		created = addon.create(outputFormat);

		if(created)
		{
			writeln("Processing file...", fileName);
			addon.callFunction("Initialize");
			addon.processTasks(fileName, tasks, true);
			addon.callFunction("Deinitialize");
		}
		else
		{
			writeln("Output format NOT found!!!");
		}
	}
	else
	{
		writeln("Failed to open ", fileName, ". File not found!");
	}
}

void processFiles(Task[][string] files, string outputFormat)
{
	auto addon = new LuaAddon;
	bool created;

	created = addon.create(outputFormat);
	addon.callFunction("Initialize");

	int numFiles = 0;

	foreach(fileName, tasks; files)
	{
		if(numFiles == (files.length - 1))
		{
			addon.processTasks(fileName, tasks, true);
		}
		else
		{
			addon.processTasks(fileName, tasks, false);
		}

		numFiles++;
	}

	addon.callFunction("Deinitialize");
}

void processDir(string dir, string outputFormat, string pattern)
{
	auto reader = new TodoFileReader;
	auto addon = new LuaAddon; // FIXME: Really we should pass this to processFiles
	bool created;
	Task[][string] files;

	created = addon.create(outputFormat);

	if(created)
	{
		writeln("Processing directories...\n");

		foreach(DirEntry e; std.parallelism.parallel(dirEntries(dir, pattern, SpanMode.breadth)))
		{
			if(e.isFile)
			{
				auto name = buildNormalizedPath(e.name);

				if(!name.startsWith("."))
				{
					Task[] tasks = reader.readFile(name);

					if(tasks.length > 0)
					{
						files[name] ~= tasks;
					}
				}
			}
		}
		processFiles(files, outputFormat);
	}
	else
	{
		writeln("Output format, ", outputFormat, ", NOT found! Aborting...");
	}
}

void handleArguments(string[] args)
{
	auto cmd = new CommandLineArgs(args);
	string dir = cmd.getValue("dir");
	string outputFormat = cmd.getValue("format");
	string pattern = cmd.getValue("pattern");

	if(cmd.isValidValue("filename"))
	{
		string fileName = cmd.getValue("filename");
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
