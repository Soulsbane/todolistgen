import std.stdio;
import ctoptions.getoptmixin;
import dapplicationbase;

@GetOptPassThru
struct Options
{
	@GetOptOptions("Sets the directory that should be scanned. [Default: .].")
	string dir;
	@GetOptOptions("The output format the results should be in. [Default: stdout].")
	string format;
	@GetOptOptions("The pattern to use. [Default: *.*]")
	string pattern;
}

class TodoListGenApp : Application!Options
{
	void processDir() @trusted
	{
	}

	override void onValidArguments()
	{
		processDir();
	}

	override void onNoArguments()
	{
		processDir();
	}
}

void main(string[] arguments)
{
	auto app = new TodoListGenApp;
	app.create("Raijinsoft", "todolistgen", arguments);
}
