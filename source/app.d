import std.stdio;
import std.string;
import std.file;

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

