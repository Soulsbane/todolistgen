module args;

import std.stdio;
import std.file;

import docopt;

string loadArgsFile(string name = "./source/args")
{
	string argsText;

	debug
    {
    	// INFO: This loads the command line interface at runtime making changes easier to debug.
    	argsText = readText(name);
    }
    else
    {
		enum eName = name;
		argsText = import(eName);
    }
    return argsText;
}