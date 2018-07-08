module api.io;

import std.string;

/**
	Reads the file into a string.

	Params:
		fileName = Name of the file to read.
*/
string readText(const string fileName)
{
	import std.file : readText;
	return readText(fileName);
}

/**
	Reads each line of the file into an array of strings.

	Params:
		fileName = Name of the file to read.
*/
string[] getLines(string fileName) @safe
{
	import std.file : readText;
	return readText(fileName).splitLines();
}
