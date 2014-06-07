import std.stdio;
import std.string;
import std.file;
import std.getopt;
import std.path;
import std.algorithm;

import todofilereader;
import todotask;
import luaaddon;

private string dir = ".";
private string pattern = "*.*";
private string outputFormat = "stdout";

void processFile(string fileName)
{
	auto reader = new TodoFileReader;
	auto addon = new LuaAddon;
	auto tasks = reader.readFile(fileName); // FIXME: Since processTasks is called for each file the output will be destroyed unless file is set to append. Really need a global tasks that can be concated to
											// FIXME: Instead of having processDir call processFile have it do it's own thing.
	addon.create(outputFormat);
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
	if(args.length > 1)
	{
		if(args[1].startsWith("--"))
		{
			getopt(args, std.getopt.config.passThrough, "help", &printHelp, "dir", &dir, "pattern", &pattern, "format", &outputFormat);
			processDir();
		}
		else
		{
			writeln("Processing file...", args[1]);
			getopt(args, std.getopt.config.passThrough, "help", &printHelp, "dir", &dir, "pattern", &pattern, "format", &outputFormat);
			processFile(args[1]);
		}
	}
	else
	{
		getopt(args, std.getopt.config.passThrough, "help", &printHelp, "dir", &dir, "pattern", &pattern, "format", &outputFormat);
		processDir();
	}
}

void printHelp()
{
	writeln("Help me obiwan...");
}

void main(string[] args)
{
	handleArguments(args);
}
