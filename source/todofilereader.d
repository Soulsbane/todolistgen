module todofilereader;

import std.stdio;
import todotask;

class TodoFileReader
{
	TodoTask[] readFile(string fileName)
	{
		TodoTask[] tasks;

		foreach(ulong i, string line; File(fileName, "r").lines)
		{
			auto task = new TodoTask;
			// FIXME: Things blow up if the file is non text.
			bool isValidTask = task.createTask(fileName, i + 1, line);

			if(isValidTask)
			{
				tasks ~= task;
			}
		}
		return tasks;
	}
}
