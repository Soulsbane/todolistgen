import std.stdio;
import std.string;
import std.file;
import std.path;
import std.range;
import std.algorithm;
import std.conv;
import std.format;
import std.array;
import std.typecons;

static import std.parallelism;

import dapplicationbase;
import dtermutils;

import constants;
import api.path;
import todofilereader;
import config;
import generator;
import extractor;

@GetOptPassThru
struct Options
{
	@GetOptOptions("Sets the directory that should be scanned. [Default: .].")
	string dir;
	@GetOptOptions("The pattern to use. [Default: *.*]")
	string pattern;
	@GetOptOptions("Will only search the passed file name.")
	string file;
	@GetOptOptions("The output format the results should be in. [Default: stdout].")
	string format;
	@GetOptOptions("A list of file extensions to ignore separated by comma. [d,cpp,rust]")
	string ignore;
	//@GetOptOptions("Used to display only the tag passed separated by commas. [INFO, FIXME, TODO]")
	//string tag;
}

class TodoListGenApp : Application!Options
{
	void setupEnvironment()
	{
		_AppPaths.setAddonName(options.getFormat("stdout"));
		ensureConfigDirExists();
	}

	override void onCreate()
	{
		setupEnvironment();
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
					addon.processTasks(fileName, tasks, Yes.isLastFile);
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
					 // TODO: Find a better way to represent hidden files
					if(!name.startsWith(".") && !isIgnoredFileType(name))
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
						addon.processTasks(fileName, files[fileName], Yes.isLastFile);
					}
					else
					{
						addon.processTasks(fileName, files[fileName], No.isLastFile);
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

	bool isIgnoredFileType(const string fileName)
	{
		immutable auto fileExtensions = options.getIgnore("").split(",");

		foreach(extension; fileExtensions)
		{
			if(fileName.endsWith(extension))
			{
				return true;
			}
		}

		return false;
	}

	override void onValidArguments()
	{
		setupEnvironment();

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
		setupEnvironment();
		processDir();
	}
}

void main(string[] arguments)
{
	auto app = new TodoListGenApp;

	extractGenerators();
	app.create(ORGANIZATION_NAME, APPLICATION_NAME, arguments);
}
