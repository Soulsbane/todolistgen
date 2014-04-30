import std.stdio;
import std.algorithm;
import std.string;
import std.regex;
import std.conv;
import std.file;
import std.typecons;

import todofileformats;
import todofilewriter;
import todofilereader;
import todotask;

void main()
{
/*	writer.write();
	writeln(thisExePath());

	foreach(DirEntry e; dirEntries(".", SpanMode.breadth))
	{
		if(!e.isDir)
		{
			writeln(e.name);
		}
	}
*/
	auto reader = new TodoFileReader;
	auto writer = todofilewriter.createFileWriter("CsvTodoFileWriters");

	auto tasks = reader.readFile("TestComments.lua");

	foreach(task; tasks)
	{
		writer.write(task);
	}
}

