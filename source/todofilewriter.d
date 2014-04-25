module todofilewriter;

import todofileformats;
import std.stdio;

interface TodoFileWriter
{
	void write();
	void writeFileName();
	void writeType();
	void writeMessage();
	void writeLineNumber();
}

class HtmlTodoFileWriter : TodoFileWriter
{
	void write()
	{
		writeln("hello HtmlTodoFileWriter.");
	}

	void writeFileName()
	{

	}

	void writeLineNumber()
	{

	}
	void writeType()
	{

	}

	void writeMessage()
	{

	}
}

class JsonTodoFileWriter : TodoFileWriter
{
	void write()
	{
		writeln("hello JsonTodoFileWriter.");
	}

	void writeFileName()
	{

	}

	void writeType()
	{

	}

	void writeLineNumber()
	{

	}

	void writeMessage()
	{

	}
}

class CsvTodoFileWriter : TodoFileWriter
{
	void write()
	{
		writeln("hello CsvTodoFileWriter.");
	}

	void writeFileName()
	{

	}

	void writeType()
	{

	}

	void writeLineNumber()
	{

	}

	void writeMessage()
	{

	}
}
TodoFileWriter createFileWriter(TodoFileFormats id)
{
	final switch(id)
	{
		case TodoFileFormats.json:
			return new JsonTodoFileWriter;
		case TodoFileFormats.csv:
			return new CsvTodoFileWriter;
		case TodoFileFormats.html:
			return new HtmlTodoFileWriter;
	}
}
