import std.stdio;
import std.string;
import std.file;
import std.path;
static import std.parallelism;

import todofilereader;
import todotask;
import luaaddon;
import args;

void processFile(string fileName, string outputFormat )
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

	foreach(DirEntry e; std.parallelism.parallel(dirEntries(dir, pattern, SpanMode.breadth)))
	{
		if(e.isFile)
		{
			auto name = buildNormalizedPath(e.name);

			if(!name.startsWith("."))
			{
				writeln(name);
				tasks ~= reader.readFile(name);
			}
		}
	}

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
	auto cmd = new CommandLineArgs(args);
	string dir = cmd.getValue("dir");
	string outputFormat = cmd.getValue("format");
	string pattern = cmd.getValue("pattern");

	if(cmd.isValidValue("filename"))
	{
		string fileName = cmd.getValue("filename");
		processFile(fileName, outputFormat);
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
