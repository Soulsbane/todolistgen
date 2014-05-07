import std.stdio;
import std.string;
import std.file;
import std.getopt;
import std.path;

import todofilewriter;
import todofilereader;
import todotask;

private string dir = ".";
private string pattern = "*.*";
private string outputFormat = "HtmlTodoFileWriter";

void processFile(string fileName)
{
	auto reader = new TodoFileReader;
	auto writer = todofilewriter.createFileWriter(outputFormat);
	auto tasks = reader.readFile(fileName);

	foreach(task; tasks)
	{
		writer.write(task);
	}
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
