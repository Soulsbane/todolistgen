module args;

import std.file;
import std.stdio;
import std.variant;
import std.string;

import docopt;

class CommandLineArgs
{
public:
	this() {}

	this(string[] args, immutable bool help = true, immutable string vers = "1.0.0")
	{
		immutable string argsText = loadArgsFile();
		auto tempArgs = docopt.docopt(argsText, args[1..$], help, vers);

		foreach(key, value; tempArgs)
		{
			auto argValue = value.value();
			args_[key.removechars("-<>")] = argValue;
		}
	}

	T getValue(T = string)(immutable string key)
	{
		return args_[key].coerce!T;
	}

	@safe bool isValidValue(immutable string key)
	{
		return (args_[key] != null);
	}

private:
	pure string loadArgsFile()
	{
		debug
		{
			// INFO: This loads the command line interface at runtime making changes easier to debug.
			import std.path;
			immutable string argsText = readText(dirName(thisExePath()) ~ buildNormalizedPath("/source/args"));
		}
		else
		{
			immutable string argsText = import("args");
		}
		return argsText;
	}

private:
	static Variant[string] args_;
}
