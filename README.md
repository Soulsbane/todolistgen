#Description
Todolistgen is a [dlang](http://dlang.org/) program that scans source code for TODO style tags and generates a file listing of todo tasks. Todolistgen

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
Information on creating and addon can be found [here](https://github.com/Soulsbane/todolistgen/blob/master/API.md)
