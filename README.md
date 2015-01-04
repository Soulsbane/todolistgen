#Description
Todolistgen is a [dlang](http://dlang.org/) program that scans source code for TODO style tags and generates a file listing of todo tasks. Todolistgen

#Output Formats
Todolistgen will create a file in the form of todo.<format> where format is json, html etc. The following output formats are included: json, html, markdown, csv and stdout(the default).

#Building
You will need a [dlang compiler](http://dlang.org/download.html) and D's build application [DUB](http://code.dlang.org/download). You should also make sure you have Lua version 5.1 library files installed which todolistgen needs for addons. After that is as simple as running the command dub on the command line.

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
>todolistgen MyFile.d


