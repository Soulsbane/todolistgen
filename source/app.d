import std.stdio;
import std.string;
import std.file;
import std.path;
import std.range;
import std.algorithm;

static import std.parallelism;

import standardpaths;

import todofilereader;
import todotask;
import luaaddon;
import args;
import config;
import api.path;
import addonextractor;
import fileremover;

void ensureConfigDirExists()
{
	immutable string configPath = getConfigDir();

	debug
	{
		string configFile = buildNormalizedPath(configPath, "config.lua");

		if(exists(configFile))
		{
			//INFO: We remove the config file here so any changes to default.config.lua will be in sync with config.lua in debug mode.
			//rmdirRecurse(configPath); //FIXME: Only remove config.lua at the very least.
			//TODO: We should probably remove addons folder also.
			remove(configFile);
		}
	}

	if(!exists(configPath))
	{
		mkdirRecurse(configPath);
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
	auto fileRemover = new FileRemover;

	ensureConfigDirExists();
	extractFiles();
	fileRemover.removeFiles();
	handleArguments(args);
}
