# Description
Todolistgen is a [dlang](http://dlang.org/) program that scans source code for TODO style tags and generates a file listing of todo tasks.

# Output Formats
Todolistgen will generate a file in the form of todo.**format** where format is json, html etc. The following output formats are included: json, html, markdown, csv and stdout(the default).

# Building
![Travis CI](https://travis-ci.org/Soulsbane/todolistgen.svg?branch=master)
You will need a [dlang compiler](http://dlang.org/download.html) and D's build application [DUB](http://code.dlang.org/download). You should also make sure you have Lua version 5.1 library files installed which are needed for addons. To build run *dub* from the command line. This will build the application in debug mode. You should use *dub --build=release.* to create a release build(requires LDC to be installed).

# Todolistgen Options
```lua
Usage:
	--dir Sets the directory that should be scanned. [Default: .].
	--pattern--pattern The pattern to use. [Default: *.*]
	--file Will only search the passed file name.
	--format The output format the results should be in. [Default: stdout].
	--ignore A list of file extensions to ignore separated by comma. [d,cpp,rust]
	--tags Used to display only the tag passed separated by commas. [INFO, FIXME, TODO]
	--create-generator Starts an interactive session used to create a new generator.
	--remove-generator Removes an installed generator.
	--list Generates a list of installed generators.
	-h             --help This help information.
```

# Example Usage
The following will scan the directory where todolistgen was ran from and output results in html.
>todolistgen --format=html

Here's an example of scanning one file only and outputing to stdout(the default).
```lua
	todolistgen TestComments.lua
	Processing file...TestComments.lua
	TestComments.lua        1       INFO    This is a quote test
	TestComments.lua        2       INFO    This is a semicolon test
	TestComments.lua        14      INFO    Panel is automatically created when including SimpleOptions.lua in your TOC.
	TestComments.lua        23      FIXME   This entire project
```
Another example using the markdown format
>Processing file...TestComments.lua
Exporting list to todo.md

## TestComments.lua
Tag | Line Number | Message
----| ------------| -------
INFO | 1|This is a quote test
INFO | 2|This is a semicolon test
NOTE | 6|Checkbutton's seem to only align with the checkbox not the checkbox plus text. ClearAllPoints may not even be needed. Needs further investigation.
INFO | 14|Panel is automatically created when including SimpleOptions.lua in your TOC.
FIXME | 23|This entire project

# Creating A Generator(Addon)
## Introduction
Creating a generator is easy. Generators are written in the Lua programming language and stored in the users home directory. If you don't know Lua already you should go [here](http://www.lua.org/pil/contents.html). You can also use [the Lua wiki](http://lua-users.org/wiki/LuaDirectory). The Learn X in Y minutes website also has a section on [Lua](http://learnxinyminutes.com/docs/lua/).

## Your First Generator(Addon)
1. Use the creator command:
>todolistgen --create-generator
2. Open the lua file you just created in your favrorite text editor. Inside this file place the following code:

	```lua
	function ProcessTasks(tasks, fileName, lastFile)
		for _, task in ipairs(tasks) do
			print(task.fileName, task.lineNumber, task.tag, task.message)
		end
	end
	```

	This is the main function todolistgen calls to process each file that contains todo tasks.
	It should be fairly obivious that *ProcessTasks* first argument is a table(tasks) and of course the second argument is the file name. The final argument is set to true if this is the last file being processed.

3. Optionally your addon can define two more functions named *OnCreate* and *OnDestroy*.
*OnCreate* is called before any files have been processed and *OnDestroy* is called after all files have been processed.
4. All that's left is testing your addon by calling todolistgen like so:
> todolistgen --format=generatorName

The API can be found [here](https://github.com/Soulsbane/todolistgen/blob/master/API.md)
