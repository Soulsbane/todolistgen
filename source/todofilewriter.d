module todofilewriter;

import todotask;
import std.stdio;

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

TodoFileWriter createFileWriter(string objStr)
{
	auto obj = Object.factory(__MODULE__ ~ "." ~ objStr);

	if(obj is null)
	{
		return new HtmlTodoFileWriter;
	}
	else
	{
		return cast(TodoFileWriter)obj;

	}
}
