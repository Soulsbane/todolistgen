module todotask;

import std.string;
import std.regex;
import std.conv;
import std.typecons;

struct Task
{
	string fileName;
	ulong lineNumber;
	string tag;
	string message;
}
