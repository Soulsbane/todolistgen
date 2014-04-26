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
	string fileName = "TestComments.lua";

	foreach(ulong i, string line; File(fileName).lines)
	{
		auto task = new TodoTask;

		bool isValidTask = task.createTask(fileName, i + 1, line);

		if(isValidTask)
		{
			tasks ~= task;
		}
	}

	auto writer = todofilewriter.createFileWriter(TodoFileFormats.html);
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

	foreach(task; tasks)
	{
		writer.write(task);

		//writeln(task.lineNumber, task.type, task.message);
	}
}
