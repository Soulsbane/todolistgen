module todofilereader;

import std.stdio;
import todotask;

class TodoFileReader
{
	TodoTask[] readFile(string fileName)
	{
		TodoTask[] tasks;

		foreach(ulong i, string line; File(fileName).lines)
		{
			auto task = new TodoTask;

			bool isValidTask = task.createTask(fileName, i + 1, line);

			if(isValidTask)
			{
				tasks ~= task;
			}
		}
		return tasks;
	}
}
