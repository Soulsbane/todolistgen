import std.stdio;
import std.string;
import std.file;
import std.path;

import todofilereader;
import todotask;
import luaaddon;
import args;

void processFile(string fileName, string dir, string outputFormat, string pattern)
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
			addon.processTasks(tasks);
		}
		else
		{
			writeln("Output format NOT found!!!");
		}
	}
}

void processDir(string dir, string outputFormat, string pattern)
{
	auto reader = new TodoFileReader;
	auto addon = new LuaAddon;
	Task[] tasks;
	bool created;

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

	/*addon.create(outputFormat);
	addon.processTasks(tasks);*/
		created = addon.create(outputFormat);

		if(created)
		{
			addon.processTasks(tasks);
		}
		else
		{
			writeln("Output format NOT found!!!");
		}
}

void handleArguments(string[] args)
{
	auto arguments = getArgs(args);
	string dir = arguments["--dir"].toString;
	string outputFormat = arguments["--format"].toString;
	string pattern = arguments["--pattern"].toString;

	if(!arguments["<filename>"].isNull)
	{
		string fileName = arguments["<filename>"].toString;

		processFile(fileName, dir, outputFormat, pattern);
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
