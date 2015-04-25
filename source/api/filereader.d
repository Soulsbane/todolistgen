module api.filereader;

import std.file;
import std.string;

string readText(string fileName) @safe
{
	return std.file.readText(fileName);
}

string[] getLines(string fileName) @safe
{
	return .readText(fileName).splitLines();
}
