module todofilereader;

import std.stdio;
import std.encoding;
import std.typecons;

import todotask;

class TodoFileReader
{
	Task[] readFile(string fileName)
	{
		Task[] tasks;
		alias Tuple!(Task, "task", bool, "isValidTask") ReturnValues;

		foreach(ulong i, string line; File(fileName, "r").lines)
		{
			if(line.isValid()) // INFO: Make sure the line is actually text.
			{
				auto task = new TodoTask;
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
