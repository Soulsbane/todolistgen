import std.stdio;
import std.string;
import std.file;
import std.path;
import std.range;
import std.algorithm;

static import std.parallelism;

import ctoptions.getoptmixin;
import dapplicationbase;

import todofilereader;

@GetOptPassThru
struct Options
{
	@GetOptOptions("Sets the directory that should be scanned. [Default: .].")
	string dir;
	@GetOptOptions("The output format the results should be in. [Default: stdout].")
	string format;
	@GetOptOptions("The pattern to use. [Default: *.*]")
	string pattern;
}

class TodoListGenApp : Application!Options
{
	void processDir() @trusted
	{
		//auto addon = new LuaAddon;
		//immutable bool created = addon.create(outputFormat);

		//if(created)
		//{
			immutable string dir = options.getDir(".");
			immutable string outputFormat = options.getFormat("stdout");
			immutable string pattern = options.getPattern("*.*");
			immutable auto filesLength = walkLength(dirEntries(dir, pattern, SpanMode.breadth));

			TaskValues[][string] files;
			//auto reader = new TodoFileReader;//FIXME: Will error at the moment since the config file doesn't exist.
			//ProgressBar progress;
			size_t counter;

			writeln(filesLength, " files to process.");
			//addon.callFunction("Initialize");
			//progress.create(filesLength, "Searching:", "Complete", 100);

			foreach(DirEntry e; std.parallelism.parallel(dirEntries(dir, pattern, SpanMode.breadth)))
			{
				++counter;
				auto name = buildNormalizedPath(e.name);

				if(e.isFile)
				{
					if(!name.startsWith(".")) // TODO: Find a better way to represent hidden files
					{
						//TaskValues[] tasks = reader.readFile(name);
						TaskValues[] tasks;

						if(tasks.length > 0)
						{
							files[name] ~= tasks;
						}
					}
				}

				//progress.update(counter);
			}

			if(files.length > 0)
			{
				counter = 0;

				foreach(fileName; sort(files.keys))
				{
					counter++;

					if(counter == files.length)
					{
						//addon.processTasks(fileName, files[fileName], true);
					}
					else
					{
						//addon.processTasks(fileName, files[fileName], false);
					}
				}
				//addon.callFunction("Deinitialize");
			}
			else
			{
				writeln("NO TASKS FOUND!");
			}
		/*}
		else
		{
			writeln(outputFormat, " output format not found!");
		}*/
	}

	override void onValidArguments()
	{
		processDir();
	}

	override void onNoArguments()
	{
		processDir();
	}
}

void main(string[] arguments)
{
	auto app = new TodoListGenApp;
	app.create("Raijinsoft", "todolistgen", arguments);
}
