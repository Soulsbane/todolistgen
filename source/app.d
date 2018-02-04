import std.stdio;
import std.string;
import std.file;
import std.path;
import std.range;
import std.algorithm;
import std.conv;
import std.format;

static import std.parallelism;
import progress;

import luaaddon.addonpaths;
import dapplicationbase;

import todofilereader;
import config;
import generator;
import extractor;
import api.path;

@GetOptPassThru
struct Options
{
	@GetOptOptions("Sets the directory that should be scanned. [Default: .].")
	string dir = ".";
	@GetOptOptions("The output format the results should be in. [Default: stdout].")
	string format = "stdout";
	@GetOptOptions("The pattern to use. [Default: *.*]")
	string pattern = "*.*";
}

class TodoListGenApp : Application!Options
{
	void start()
	{
		addonPaths_ = new ApplicationPaths(options.getFormat());
		ensureConfigDirExists();
		extractGenerators(options.getFormat("stdout"));
	}

	void ensureConfigDirExists() @trusted
	{
		immutable string configPath = addonPaths_.getConfigFilesDir();

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

	void processDir() @trusted
	{
		//TODO: Change Initialize and Deinitialize to OnCreate and OnDestroy.
		auto addon = new Generator;
		immutable bool created = addon.create(options.getFormat("stdout"));

		if(created)
		{
			immutable string dir = options.getDir(".");
			immutable string outputFormat = options.getFormat("stdout");
			immutable string pattern = options.getPattern("*.*");
			immutable auto filesLength = walkLength(dirEntries(dir, pattern, SpanMode.breadth));

			TaskValues[][string] files;
			auto reader = new TodoFileReader;//FIXME: Will error at the moment since the config file doesn't exist.
			//ProgressBar progress;
			ShadyBar b = new ShadyBar();
			size_t counter;

			b.message = {return "Processing";};
			b.suffix = {return format("%0.0f", b.percent).to!string ~ "% ";};
			b.width = 64;
			b.max = filesLength;

			writeln(filesLength, " files to process.");
			addon.callFunction("Initialize");
			//progress.create(filesLength, "Searching:", "Complete", 100);

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

				//progress.update(counter);
				b.next();
			}

			b.finish();

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
			writeln(options.getFormat("stdout"), " output format not found!");
		}
	}

	override void onValidArguments()
	{
		processDir();
	}

	override void onNoArguments()
	{
		processDir();
	}

private:
	ApplicationPaths addonPaths_;
	immutable string applicationName_ = "todolistgen";
	immutable string organizationName_ = "Raijinsoft";
}

void main(string[] arguments)
{
	auto app = new TodoListGenApp;
	app.create(ORGANIZATIONNAME, APPLICATIONNAME, arguments);
	app.start();
}
