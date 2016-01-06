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

	T getValue(T = string)(const string key) @safe const
	{
		return to!T(args_[key]);
	}

	bool isValidValue(const string key) @safe
	{
		return (args_[key] != null);
	}

private:
	static string[string] args_;
}
