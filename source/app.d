import std.stdio;
import std.algorithm;
import std.string;
import std.regex;
import std.conv;
import std.file;
import std.typecons;

import todofileformats;
import todofilewriter;
import todotask;

void main()
{
	TodoTask[] tasks;

	foreach(ulong i, string line; File("TestComments.lua").lines)
	{
		auto task = new TodoTask;

		bool isValidTask = task.createTask(i + 1, line);

		if(isValidTask)
		{
			tasks ~= task;
		}
	}

/*	auto writer = todofilewriter.createFileWriter(TodoFileFormats.json);
	writer.write();
	writeln(thisExePath());

	foreach(DirEntry e; dirEntries(".", SpanMode.breadth))
	{
		if(!e.isDir)
		{
			writeln(e.name);
		}
	}
*/

	foreach(task; tasks)
	{
		writeln(task.lineNumber, task.type, task.message);
	}
}
