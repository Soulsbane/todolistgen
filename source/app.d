import std.stdio;
import std.string;
import std.file;
import std.path;
import std.range;
import std.algorithm;

static import std.parallelism;

import standardpaths;
import raijin.terminal.progressbar;
import raijin.utils.string;

import todofilereader;
import todotask;
import luaaddon;
import args;
import api.path;
import addonextractor;
import fileremover;

void ensureConfigDirExists() @trusted
{
	immutable string configPath = getConfigFilesDir();

	debug
	{
		immutable string configFile = buildNormalizedPath(configPath, "config.lua");

		if(configFile.exists)
		{
			//INFO: We remove the config file here so any changes to default.config.lua will be in sync with config.lua in debug mode.
			configFile.remove;
		}
	}

	if(!configPath.exists)
	{
		configPath.mkdirRecurse;
	}
}

void processFile(const string fileName, const string outputFormat) @trusted
{
	if(fileName.exists)
	{
		auto addon = new LuaAddon;
		immutable bool created = addon.create(outputFormat);

		if(created)
		{
			auto reader = new TodoFileReader;
			auto tasks = reader.readFile(fileName);

			writeln("Processing ", fileName);

			if(tasks.length > 0)
			{
				addon.callFunction("Initialize");
				addon.processTasks(fileName, tasks, true);
				addon.callFunction("Deinitialize");
			}
			else
			{
				writeln("NO TASKS FOUND!");
			}
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

void processDir(const string dir, const string outputFormat, const string pattern) @trusted
{
	auto addon = new LuaAddon;
	immutable bool created = addon.create(outputFormat);

	if(created)
	{
		auto reader = new TodoFileReader;
		TaskValues[][string] files;
		immutable auto filesLength = walkLength(dirEntries(dir, pattern, SpanMode.breadth));
		ProgressBar progress;
		size_t counter;

		writeln(filesLength, " files to process.");
		addon.callFunction("Initialize");
		progress.create(filesLength, "Searching:", "Complete", 100);

		foreach(DirEntry e; std.parallelism.parallel(dirEntries(dir, pattern, SpanMode.breadth)))
		{
			++counter;
			auto name = buildNormalizedPath(e.name);

			if(e.isFile)
			{
				if(!name.startsWith(".")) // TODO: Find a better way to represent hidden files
				{
					TaskValues[] tasks = reader.readFile(name);

					if(tasks.length > 0)
					{
						files[name] ~= tasks;
					}
				}
			}
			progress.update(counter);
		}


		if(files.length > 0)
		{
			counter = 0;

			foreach(fileName; sort(files.keys))
			{
				counter++;

				if(counter == files.length)
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
			writeln("NO TASKS FOUND!");
		}
	}
	else
	{
		writeln(outputFormat, " output format not found!");
	}
}

void handleArguments(string[] args) @trusted
{
	initializeGetOpt(args);

	if(args.length > 1)
	{
		immutable string value = args[1];

		if(value.startsWithOr("--dir", "--format", "--pattern"))
		{
			processDir(_Args.dir, _Args.format, _Args.pattern);
		}
		else
		{
			if(!value.startsWith("--help"))
			{
				processFile(value, _Args.format);
			}
		}
	}
	else
	{
		processDir(_Args.dir, _Args.format, _Args.pattern);
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
