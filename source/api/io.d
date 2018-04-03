module api.io;

import std.string;

string readText(const string fileName)
{
	import std.file : readText;
	return readText(fileName);
}

string[] getLines(string fileName) @safe
{
	import std.file : readText;
	return readText(fileName).splitLines();
}
