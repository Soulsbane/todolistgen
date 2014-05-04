module todofilereader;

import std.stdio;
import std.encoding;

import todotask;

class TodoFileReader
{
	TodoTask[] readFile(string fileName)
	{
		TodoTask[] tasks;

		foreach(ulong i, string line; File(fileName, "r").lines)
		{
			if(line.isValid()) // INFO: Make sure the line is actually text.
			{
				auto task = new TodoTask;

				bool isValidTask = task.createTask(fileName, i + 1, line);
				if(isValidTask)
				{
					tasks ~= task;
				}
			}
		}
		return tasks;
	}
}
