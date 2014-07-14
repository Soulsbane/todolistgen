import std.stdio;
import std.string;
import std.file;
import std.getopt;
import std.path;
import std.algorithm;
import std.conv;

import todofilereader;
import todotask;
import luaaddon;
import args;

private string dir = ".";
private string pattern = "*.*";
private string outputFormat = "stdout";

void processFile(string fileName)
{
	if(exists(fileName))
	{
		auto reader = new TodoFileReader;
		auto addon = new LuaAddon;
		auto tasks = reader.readFile(fileName);

		writeln("Processing file...", fileName);
		addon.create(outputFormat);
		addon.processTasks(tasks);
	}
}

void processDir()
{
	auto reader = new TodoFileReader;
	auto addon = new LuaAddon;
	Task[] tasks;

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
				tasks ~= reader.readFile(name);
			}
		}
	}

	addon.create(outputFormat);
	addon.processTasks(tasks);
}

void handleArguments(string[] args)
{
	auto arguments = getArgs(args);

	dir = arguments["--dir"].toString;
	outputFormat = arguments["--format"].toString;
	pattern = arguments["--pattern"].toString;

	if(!arguments["<filename>"].isNull)
	{
		string fileName = arguments["<filename>"].toString;

		processFile(fileName);
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
	handleArguments(args);
}
