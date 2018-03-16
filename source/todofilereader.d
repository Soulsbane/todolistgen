module todofilereader;

import std.stdio;
import std.encoding;
import std.string;
import std.regex;
import std.conv;
import std.file;

import config;

alias TaskValues = string[string];

class TodoFileReader
{
public:
	this()
	{
		patterns_ = getConfigPattern();
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
		TaskValues values;

		foreach(pattern; patterns_)
		{
			auto re = regex(patterns_, "g");
			auto match = matchFirst(line, re);
			auto nc = re.namedCaptures;
			immutable size_t numNamedCaptures = nc.length - 1;

			if(match)
			{
				values["fileName"] = curFileName;
				values["lineNumber"] = to!string(lineNum);

				for(int i; i <= numNamedCaptures; i++)
				{
					values[to!string(nc[i])] = to!string(match[nc[i]]);
				}
			}
		}

		return values;
	}

	string[] getConfigPattern() const @trusted
	{
		auto variable = _Config.getTable("TodoTaskPatterns");
		string[] found;

		foreach(string key, bool value; variable)
		{
			if(value == true)
			{
				found ~= key;
			}
		}

		return found;
	}

private:
	string[] patterns_;
}
