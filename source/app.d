import std.stdio;
import std.string;
import std.file;
import std.path;
import std.range;
import std.algorithm;
import std.conv;
import std.format;

static import std.parallelism;

import dapplicationbase;
import dtermutils;

import todofilereader;
import config;
import generator;
import extractor;
import api.path;

@GetOptPassThru
struct Options
{
	@GetOptOptions("Sets the directory that should be scanned. [Default: .].")
	string dir;
	@GetOptOptions("The pattern to use. [Default: *.*]")
	string pattern;
	@GetOptOptions("Will search only seach the file that was passed.")
	string file;
	@GetOptOptions("The output format the results should be in. [Default: stdout].")
	string format;
}

class TodoListGenApp : Application!Options
{
	void start()
	{
		_AppPaths.setAddonName(options.getFormat("stdout"));
		ensureConfigDirExists();
	}

	void ensureConfigDirExists() @trusted
	{
		immutable string configPath = _AppPaths.getConfigFilesDir();

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

	void processFile(const string fileName) @trusted
	{
		if(fileName.exists)
		{
			auto addon = new Generator;
			immutable bool created = addon.create(options.getFormat("stdout"));

			if(created)
			{
				auto reader = new TodoFileReader;
				auto tasks = reader.readFile(fileName);

				writeln("Processing ", fileName);

				if(tasks.length > 0)
				{
					addon.callFunction("OnCreate");
					addon.processTasks(fileName, tasks, true);
					addon.callFunction("OnDestroy");
				}
				else
				{
					writeln("NO TASKS FOUND!");
				}
			}
			else
			{
				writeln(options.getFormat("stdout"), " output format not found!");
			}
		}
		else
		{
			writeln("Failed to open ", fileName, ". File not found!");
		}
	}

	void processDir() @trusted
	{
		auto addon = new Generator;
		immutable bool created = addon.create(options.getFormat("stdout"));

		if(created)
		{
			immutable string dir = options.getDir(".");
			immutable string pattern = options.getPattern("*.*");
			immutable auto filesLength = walkLength(dirEntries(dir, pattern, SpanMode.breadth));

			TaskValues[][string] files;
			auto reader = new TodoFileReader;
			ProgressBar progress;
			size_t counter;

			writeln(filesLength, " files to process.");
			addon.callFunction("OnCreate");
			progress.create(filesLength, "Searching:", "Complete", 100);

			foreach(DirEntry e; std.parallelism.parallel(dirEntries(dir, pattern, SpanMode.breadth)))
			{
				++counter;
				immutable string name = buildNormalizedPath(e.name);

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

				addon.callFunction("OnDestroy");
			}
			else
			{
				writeln("NO TASKS FOUND!");
			}
		}
		else
		{
			writeln(options.getFormat("stdout"), " output format not found!");
		}
	}

	override void onValidArguments()
	{
		if(options.hasFile()) // --file argument was passed
		{
			immutable string fileName = options.getFile();
			processFile(fileName);
		}
		else
		{
			processDir();
		}
	}

	override void onNoArguments()
	{
		processDir();
	}
}

void main(string[] arguments)
{
	auto app = new TodoListGenApp;

	extractGenerators();
	app.create(ORGANIZATION_NAME, APPLICATION_NAME, arguments);
	app.start();
}
