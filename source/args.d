module args;

import raijin.utils.getoptmixin;
import raijin.utils.debugtools;

@GetOptPassThru
struct ValidArguments
{
	@GetOptDescription("Sets the directory that should be scanned. [Default: .].")
	string dir;
	@GetOptDescription("The output format the results should be in. [Default: stdout].")
	string format;
	@GetOptDescription("The pattern to use. [Default: *.*]")
	string pattern;
}

ValidArguments _Args;

void initializeGetOpt(string[] arguments)
{
	_Args.dir = ".";
	_Args.format = "stdout";
	_Args.pattern = "*.*";

	generateGetOptCode!ValidArguments(arguments, _Args);
}
