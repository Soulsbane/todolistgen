module todofilereader;

import std.stdio;
import std.encoding;

import todotask;

class TodoFileReader
{
	Task[] readFile(string fileName)
	{
		Task[] tasks;

		foreach(ulong i, string line; File(fileName, "r").lines)
		{
			if(line.isValid()) // INFO: Make sure the line is actually text.
			{
				auto task = new TodoTask;

				auto isValidTask = task.createTask(fileName, i + 1, line);

				if(isValidTask[1])
				{
					tasks ~= isValidTask[0];
				}
			}
		}
		return tasks;
	}
}
