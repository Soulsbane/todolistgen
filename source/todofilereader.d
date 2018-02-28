module todofilereader;

import std.stdio;
import std.encoding;
import std.string;
import std.regex;
import std.conv;
import std.file;

import config;

alias string[string] TaskValues;

class TodoFileReader
{
public:
	this()
	{
		pattern_ = getConfigPattern();
	}

	TaskValues[] readFile(const string fileName) @trusted
	{
		TaskValues[] tasks;

		foreach(ulong i, string line; File(fileName, "r").lines)
		{
			if(line.isValid) // INFO: Make sure the line is actually text.
			{
				auto values = createTask(fileName, i + 1, line);
				if(values.length > 0)
				{
					tasks ~= values;
				}
			}
		}
		return tasks;
	}

private:
	TaskValues createTask(const string curFileName, const ulong lineNum, const string line) @safe
	{
		auto re = regex(pattern_, "g");
		auto match = matchFirst(line, re);
		auto nc = re.namedCaptures;
		TaskValues values;

		if(match)
		{
			values["fileName"] = curFileName;
			values["lineNumber"] = to!string(lineNum);

			for(int i = 0; i <= (nc.length - 1); i++)
			{
				values[to!string(nc[i])] = to!string(match[nc[i]]);
			}
		}
		return values;
	}

	string getConfigPattern() @trusted const
	{
		auto config = new Config;
		config.load("config.lua");

		auto variable = config.getTable("TodoTaskPatterns");
		string found;

		foreach(string key, bool value; variable)
		{
			if(value == true)
			{
				found = key; // NOTE: This isn't a bug. Support for multiple patterns to match will be added later.
			}
		}

		return found;
	}

private:
	string pattern_;
}
