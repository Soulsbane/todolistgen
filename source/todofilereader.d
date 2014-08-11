module todofilereader;

import std.stdio;
import std.encoding;
import std.string;
import std.regex;
import std.conv;
import std.file;

import config;
import todotask;

class TodoFileReader
{
public:
	Task[] readFile(string fileName)
	{
		Task[] tasks;

		foreach(ulong i, string line; File(fileName, "r").lines)
		{
			if(line.isValid()) // INFO: Make sure the line is actually text.
			{
				auto task = createTask(fileName, i + 1, line);

				if(Task.init != task) // INFO: If the returned task contains nothing but default values then don't add it to task array.
				{
					tasks ~= task;
				}
			}
		}
		return tasks;
	}

private:
	Task createTask(string fileName, ulong lineNum, string str)
	{
		Config cfg;
		auto vars =	cfg.load();
		auto r = regex(getConfigPattern(), "g"); // INFO: The first match catches the tag and the second the message.
		auto m = matchAll(str, r);
		Task task;

		if(m)
		{
			task.fileName = fileName;
			task.lineNumber = lineNum;
			task.tag = to!string(strip(m.captures[1]));
			task.message = to!string(strip(m.captures[2]));
		}
		return task;
	}

	string getConfigPattern()
	{
		auto config = new LuaConfig;
		config.load();
		auto variable = config.getVariable("TodoTaskPatterns");

		string found;
		foreach(string key, bool value; variable)
		{
			if(value == true)
			{
				found = key;
			}
		}

		return found;
	}
}
