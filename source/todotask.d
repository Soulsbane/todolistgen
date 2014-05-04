module todotask;

import std.string;
import std.regex;
import std.conv;

class TodoTask
{
	bool createTask(string fileName, ulong lineNum, string str)
	{
		auto r = ctRegex!(r"([A-Z]+):(.*)", "g"); // INFO: The first match catches the type and the second the message.
		auto m = matchAll(str, r);

		if(m)
		{
			fileName_ = fileName;
			lineNumber_ = lineNum;
			type_ = to!string(strip(m.captures[1]));
			message_ = to!string(strip(m.captures[2]));

			return true;
		}
		else
		{
			return false;
		}
	}

	@property string fileName() const
	{
		return fileName_;
	}

	@property ulong lineNumber() const
	{
		return lineNumber_;
	}

	@property string type() const
	{
		return type_;
	}

	@property string message() const
	{
		return message_;
	}

private:
	string fileName_;
	ulong lineNumber_;
	string type_;
	string message_;
}
