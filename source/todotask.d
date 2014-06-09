module todotask;

import std.string;
import std.regex;
import std.conv;
import std.typecons;

alias Tuple!(Task, "task", bool, "isValidTask") ReturnValues;

struct Task
{
	string fileName;
	ulong lineNumber;
	string tag;
	string message;
}

class TodoTask
{
	auto createTask(string fileName, ulong lineNum, string str)
	{
		auto r = ctRegex!(r"([A-Z]+):(.*)", "g"); // INFO: The first match catches the tag and the second the message.
		auto m = matchAll(str, r);
		Task task;

		if(m)
		{
			task.fileName = fileName;
			task.lineNumber = lineNum;
			task.tag = to!string(strip(m.captures[1]));
			task.message = to!string(strip(m.captures[2]));

			return ReturnValues(task, true);
		}
		else
		{
			return ReturnValues(task, false);
		}
	}
}
