module todofilewriter;

import std.stdio;
import std.algorithm;
import std.string;

import todotask;

interface TodoFileWriter
{
	void write(TodoTask task);
	void writeFileName(string fileName);
	void writeType(string type);
	void writeMessage(string message);
	void writeLineNumber(ulong lineNumber);
}

class HtmlTodoFileWriter : TodoFileWriter
{
	void write(TodoTask task)
	{
		writeln(task.fileName, task.lineNumber, task.type, task.message);
	}

	void writeFileName(string fileName)
	{

	}

	void writeLineNumber(ulong lineNumber)
	{

	}
	void writeType(string type)
	{

	}

	void writeMessage(string message)
	{

	}
}

class JsonTodoFileWriter : TodoFileWriter
{
	void write(TodoTask task)
	{
		writeln("hello JsonTodoFileWriter.");
	}

	void writeFileName(string fileName)
	{

	}

	void writeType(string type)
	{

	}

	void writeLineNumber(ulong lineNumber)
	{

	}

	void writeMessage(string message)
	{

	}
}

class CsvTodoFileWriter : TodoFileWriter
{
	void write(TodoTask task)
	{
		writeln("hello CsvTodoFileWriter.");
	}

	void writeFileName(string fileName)
	{

	}

	void writeType(string type)
	{

	}

	void writeLineNumber(ulong lineNumber)
	{

	}

	void writeMessage(string message)
	{

	}
}

class MarkdownTodoFileWriter : TodoFileWriter
{
	void write(TodoTask task)
	{
		writeln("hello MarkdownTodoFileWriter.");
	}

	void writeFileName(string fileName)
	{

	}

	void writeType(string type)
	{

	}

	void writeLineNumber(ulong lineNumber)
	{

	}

	void writeMessage(string message)
	{

	}
}

TodoFileWriter createFileWriter(string outputFormat)
{
	string className;

	foreach(mod; ModuleInfo) {
		foreach(cla; mod.localClasses) {
			foreach(inter; cla.interfaces)
			{
				auto info = inter.classinfo;
				if(info.name == "todofilewriter.TodoFileWriter")
				{
					if(outputFormat != "HtmlTodoFileWriter")
					{
						if(cla.name.startsWith(__MODULE__ ~ "." ~ outputFormat.capitalize))
						{
							className = cla.name;
						}
					}
				}
			}
		}
	}

	auto obj = Object.factory(className);

	if(obj is null)
	{
		return new HtmlTodoFileWriter;
	}
	else
	{
		return cast(TodoFileWriter)obj;
	}
}
