import std.stdio;
import std.string;
import std.file;
import std.getopt;
import std.path;

import todofilereader;
import todotask;
import luaaddon;

private string dir = ".";
private string pattern = "*.*";
private string outputFormat = "stdout";

void processFile(string fileName)
{
	auto reader = new TodoFileReader;
	auto addon = luaaddon.createAddon(outputFormat);
	auto tasks = reader.readFile(fileName);

	addon.processTasks(tasks);
}

void processDir()
{
	foreach(DirEntry e; dirEntries(dir, pattern, SpanMode.breadth))
	{
		if(e.isFile)
		{
			auto name = buildNormalizedPath(e.name);

			if(name.startsWith("."))
			{
				continue;
			}
			else
			{
				processFile(name);
			}
		}
	}
}

void handleArguments(string[] args)
{
	getopt(args, std.getopt.config.passThrough, "help", &printHelp, "dir", &dir, "pattern", &pattern, "format", &outputFormat);

	if(args.length == 2) { //NOTE: If there is only one argument then we assume the user wants one file processed.
		processFile(args[1]);
	}
	else
	{
		processDir();
	}
}

void printHelp()
{
	writeln("Help me obiwan...");
}

void main(string[] args)
{
	//writeln(thisExePath());
	handleArguments(args);
}
