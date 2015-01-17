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
	this()
	{
		pattern_ = getConfigPattern();
	}

	Task[] readFile(immutable string fileName)
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
	@safe Task createTask(immutable string curFileName, immutable ulong lineNum, immutable string line)
	{
		auto todoTaskPattern = regex(pattern_, "g"); // TODO: Add support for multiple patterns
		auto match = matchAll(line, todoTaskPattern);
		Task task;

		if(match)
		{
			with(task)
			{
				fileName = curFileName;
				lineNumber = lineNum;
				tag = to!string(strip(match.captures[1]));
				message = to!string(strip(match.captures[2]));
			}
		}
		return task;
	}

	@trusted string getConfigPattern()
	{
		auto config = new LuaConfig;
		config.load();
		auto variable = config.getTable("TodoTaskPatterns");

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

private:
	string pattern_;
}
