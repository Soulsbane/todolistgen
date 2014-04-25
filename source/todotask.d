module todotask;
import std.stdio;
import std.algorithm;
import std.string;
import std.regex;
import std.conv;
import std.file;
import std.typecons;

enum AnnotationType
{
	warnings,
	notes,
	errors
}

class TodoTask
{
	bool createTask(ulong lineNum, string str)
	{
		auto r = ctRegex!(r"([A-Z]+):(.*)", "g"); // INFO: The first match catches the type and the second the message.
		auto m = matchAll(str, r);

		if(m)
		{
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
	ulong lineNumber_;
	string type_;
	string message_;
}
