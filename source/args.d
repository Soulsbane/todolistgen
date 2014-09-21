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

	this(string[] args, bool help = true, string vers = "1.0.0")
	{
		string argsText = loadArgsFile();
		auto tempArgs = docopt.docopt(argsText, args[1..$], help, vers);

		foreach(key, value; tempArgs)
		{
			auto argValue = value.value();
			args_[key.removechars("-<>")] = argValue;
		}
	}

	T getValue(T = string)(string key)
	{
		return args_[key].coerce!T;
	}

	bool isValidValue(string key)
	{
		return (args_[key] != null);
	}

private:
	string loadArgsFile()
	{
		string argsText;

		debug
		{
			// INFO: This loads the command line interface at runtime making changes easier to debug.
			import std.path;
			argsText = readText(dirName(thisExePath()) ~ buildNormalizedPath("/source/args"));
		}
		else
		{
			argsText = import("args");
		}
		return argsText;
	}

private:
	static Variant[string] args_;
}
