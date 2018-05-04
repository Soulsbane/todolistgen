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

	TaskValues[] readFile(const string fileName, const string tags = string.init) @trusted
	{
		TaskValues[] tasks;

		foreach(ulong i, string line; File(fileName, "r").lines)
		{
			if(line.isValid) // INFO: Make sure the line is actually text.
			{
				auto values = createTask(fileName, i + 1, line);

				if(values.length > 0)
				{
					// INFO: Check for a valid tag if the --tags option has a value.
					if(values["tag"] && tags != string.init)
					{
						if(checkForValidTag(values["tag"], tags))
						{
							tasks ~= values;
						}
					}
					else
					{
						tasks ~= values;
					}
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

			if(match)
			{
				auto nc = re.namedCaptures;

				if(nc.length != 0)
				{
					immutable size_t numNamedCaptures = nc.length - 1;

					values["fileName"] = curFileName;
					values["lineNumber"] = to!string(lineNum);

					for(int i; i <= numNamedCaptures; i++)
					{
						immutable string key = to!string(nc[i]);
						immutable string value = to!string(match[nc[i]]);

						values[key] = value;
					}
				}
			}
		}

		return values;
	}

	string[] getConfigPattern() const @trusted
	{
		auto config = Config.getInstance();
		auto variable = config.getTable("TodoTaskPatterns");
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

	bool checkForValidTag(const string tag, const string optionTags)
	{
		immutable auto splitTags = optionTags.split(",");

		foreach(splitTag; splitTags)
		{
			if(tag == splitTag)
			{
				return true;
			}
		}

		return false;
	}

private:
	string[] patterns_;
}
