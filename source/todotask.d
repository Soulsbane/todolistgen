module todotask;

import std.string;
import std.regex;
import std.conv;
import std.typecons;

struct Task
{
	string fileName;
	ulong lineNumber;
	string type;
	string message;
}

class TodoTask
{
	auto createTask(string fileName, ulong lineNum, string str)
	{
		auto r = ctRegex!(r"([A-Z]+):(.*)", "g"); // INFO: The first match catches the type and the second the message.
		auto m = matchAll(str, r);
		alias Tuple!(Task, "task", bool, "isValidTask") ReturnValues;
		Task task;

		if(m)
		{
			task.fileName = fileName;
			task.lineNumber = lineNum;
			task.type = to!string(strip(m.captures[1]));
			task.message = to!string(strip(m.captures[2]));

			return ReturnValues(task, true);
		}
		else
		{
			return ReturnValues(task, false);
		}
	}
}
