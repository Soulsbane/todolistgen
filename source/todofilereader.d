module todofilereader;

import std.stdio;
import std.encoding;
import std.typecons;

import todotask;

alias Tuple!(Task, "task", bool, "isValidTask") ReturnValues;

class TodoFileReader
{
	Task[] readFile(string fileName)
	{
		Task[] tasks;
		auto task = new TodoTask;

		foreach(ulong i, string line; File(fileName, "r").lines)
		{
			if(line.isValid()) // INFO: Make sure the line is actually text.
			{
				ReturnValues values = task.createTask(fileName, i + 1, line);

				if(values.isValidTask)
				{
					tasks ~= values.task;
				}
			}
		}
		return tasks;
	}
}
