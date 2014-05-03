import std.stdio;
import std.string;
import std.file;
import std.getopt;

import todofilewriter;
import todofilereader;
import todotask;

void processFile(string fileName)
{
	auto reader = new TodoFileReader;
	auto writer = todofilewriter.createFileWriter("CsvTodoFileWriters");
	auto tasks = reader.readFile(fileName);

	foreach(task; tasks)
	{
		writer.write(task);
	}
}

void processDir(string option, string value)
{
	writeln("Processing dir: ", value);

	foreach(DirEntry e; dirEntries(".", SpanMode.breadth))
	{
		if(!e.isDir)
		{
			writeln(e.name);
		}
	}
}

void handleArguments(string[] args)
{
	getopt(args, std.getopt.config.passThrough, "help", &printHelp, "dir", &processDir);

	if(args.length > 1) { //NOTE: If there is only one argument then we assume the user wants one file processed.
		processFile(args[1]);
	}
}

void printHelp()
{
	writeln("Help me obiwan...");
}

void main(string[] args)
{
	writeln(thisExePath());
	handleArguments(args);
}
