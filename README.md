#Description
Todolistgen is a [dlang](http://dlang.org/) program that scans source code for TODO style tags and generates a file listing of todo tasks.

#Output Formats
Todolistgen will generate a file in the form of todo.**format** where format is json, html etc. The following output formats are included: json, html, markdown, csv and stdout(the default).

#Building
You will need a [dlang compiler](http://dlang.org/download.html) and D's build application [DUB](http://code.dlang.org/download). You should also make sure you have Lua version 5.1 library files installed which are needed for addons. After that is as simple as running the command dub on the command line.

#Todolistgen Options
>
    Usage:
      todolistgen
      todolistgen [--dir=<dir>] [--format=<format>] [--pattern=<pattern>] [--output=<outputpath>]
      todolistgen <filename>
      todolistgen <filename> [--dir=<dir>] [--format=<format>] [--pattern=<pattern>] [--output=<outputpath>]
      todolistgen -h | --help
      todolistgen --version
    Options:
      -h --help     Show help.
      --version     Show version.
      --dir=<dir>   Directory [default: .].
      --format=<json|html|markdown|csv|stdout>   Format [default: stdout].
      --pattern=<pattern>   Pattern [default: *.*].
      --output<outputpath>   Directory to output the resulting todo file.

#Example Usage
The following will scan the directory where todolistgen was ran from and output results in html.
>todolistgen --format=html

Here's an example of scanning one file only and outputing to stdout(the default).

 >todolistgen TestComments.lua
Processing file...TestComments.lua
TestComments.lua        1       INFO    This is a quote test
TestComments.lua        2       INFO    This is a semicolon test
TestComments.lua        6       NOTE    Checkbutton's seem to only align with the checkbox not the checkbox plus text. ClearAllPoints may not even be needed. Needs further investigation.
TestComments.lua        14      INFO    Panel is automatically created when including SimpleOptions.lua in your TOC.
TestComments.lua        23      FIXME   This entire project

Another example using the markdown format
>Processing file...TestComments.lua
Exporting list to.../home/soulsbane/Projects/D/todolistgen/todo.md

## TestComments.lua
Tag | Line Number | Message
----| ------------| -------
INFO | 1|This is a quote test
INFO | 2|This is a semicolon test
NOTE | 6|Checkbutton's seem to only align with the checkbox not the checkbox plus text. ClearAllPoints may not even be needed. Needs further investigation.
INFO | 14|Panel is automatically created when including SimpleOptions.lua in your TOC.
FIXME | 23|This entire project

#Creating An Output Format(Addon)
## Introduction
Creating an output format is easy. From here on I'll refer to the output format as an addon. Addons are written in the Lua programming language and stored in the addons directory of the todolistgen directory.. If you don't know Lua already you should go [here](http://www.lua.org/pil/contents.html). You can also use [the Lua wiki](http://lua-users.org/wiki/LuaDirectory). The Learn X in Y minutes website also has a section on [Lua](http://learnxinyminutes.com/docs/lua/).

## Your First Addon
1. Create a folder in the addons directory of todolistgen. It can be any name but for consistency try to use lowercase. No spaces are allowed either.
2. In your addons directory create a file with the same name as the directory you just created with the file extension lua.
3. Open the lua file you just created in your favrorite text editor. Inside this file place the following code:
```lua
function ProcessTasks(tasks, fileName)
	for _, task in ipairs(tasks) do
		print(task.fileName, task.lineNumber, task.tag, task.message)
	end
end
	```
This is the main function that Todolistgen calls to process each file that contains todo tasks.
It should be fairly obivious that *ProcessTasks* first argument is a table(tasks) and of course the second argument is the file name.
4. Optionally your addon can define two more functions named *Initialize* and *Deinitialize*.
*Intialize* is called before any files have been processed and *Deinitialize* is called after all files have been processed.
5. All that's left is testing your addon by calling todolistgen with the *--format* option like below:
> todolistgen --format=addonname

Information on the API can be found [here](https://github.com/Soulsbane/todolistgen/blob/master/API.md)
