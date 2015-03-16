module api.filereader;

import std.file;
import std.string;

string readText(string fileName)
{
	return .readText(fileName);
}

string[] getLines(string fileName)
{
	return .readText(fileName).splitLines();
}
