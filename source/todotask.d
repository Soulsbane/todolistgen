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

struct Task
{
	ulong lineNumber;
	string type;
	string message;
	bool isValid;
}
// TODO: Nix the Task strruct and incorporate it into this class
class TodoTask
{
	Task task;

	ulong lineNumber;
	string type;
	string message;

	bool createTask(ulong lineNum, string str)
	{
		auto r = ctRegex!(r"([A-Z]+):(.*)", "g"); // INFO: The first match catches the type and the second the message.
		auto m = matchAll(str, r);

		if(m)
		{
			lineNumber = lineNum;
			type = to!string(strip(m.captures[1]));
			message = to!string(strip(m.captures[2]));
			return true;
		}
		else
		{
			return false;
		}
	}
}
