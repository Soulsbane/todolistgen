module args;

import std.getopt;
import std.conv;
import std.stdio;

static void printHelp()
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

	T getValue(T = string)(immutable string key)
	{
		return to!T(args_[key]);
	}

	@safe bool isValidValue(immutable string key)
	{
		return (args_[key] != null);
	}

private:
	static string[string] args_;
}
