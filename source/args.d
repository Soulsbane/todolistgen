module args;

import std.getopt;
import std.conv;
import std.stdio;

static void printHelp() @trusted
{
	immutable string argsText = import("args");
	writeln(argsText);
}

class CommandLineArgs
{
public:
	this() {}

	this(string[] args)
	{
		args_["dir"] = ".";
		args_["format"] = "stdout";
		args_["pattern"] = "*.*";

		getopt(args, std.getopt.config.passThrough, "dir", &args_["dir"], "format", &args_["format"], "pattern", &args_["pattern"], "help", &printHelp);
	}

	T getValue(T = string)(immutable string key) @safe
	{
		return to!T(args_[key]);
	}

	bool isValidValue(immutable string key) @safe
	{
		return (args_[key] != null);
	}

private:
	static string[string] args_;
}
