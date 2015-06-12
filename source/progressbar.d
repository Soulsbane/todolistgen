/* The MIT License (MIT)

Copyright (c) 2015 Kazuya Gokita

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE. */

// INFO: This is a fork of https://github.com/kazoo04/progress-d. I've removed things
// that were not needed/wouldn't work for todolistgen and fixed a few bugs here and
// there.

module progressbar;

import std.stdio;
import std.range;
import std.format;
import std.datetime;
import core.sys.posix.unistd;
import core.sys.posix.sys.ioctl;

class Progress
{
	abstract void update(immutable string fileName);

	final void clear()
	{
		write("\x1B[2K");
		write("\r");
	}
}

class ProgressBar : Progress
{
private:
	size_t getTerminalWidth()
	{
		size_t column;
		winsize ws;

		if(ioctl(STDOUT_FILENO, TIOCGWINSZ, &ws) != -1)
		{
			column = ws.ws_col;
		}

		if(column == 0)
		{
			column = defaultWidth_;
		}

		return column;
	}

	string getProgressBarText(immutable string headerText)
	{
		immutable auto ratio = cast(double)counter_ / iterations_;
		string result;
		double barLength = width_ - headerText.length;

		if(barLength > maxWidth_ && maxWidth_ > 0)
		{
			barLength = maxWidth_;
		}

		size_t i = 0;

		for(; i < ratio * barLength; i++)
		{
			result ~= "o";
		}

		for(; i < barLength; i++)
		{
			result ~= "-";
		}

		return headerText ~ result;
	}

	void updateProgressBar()
	{
		immutable auto ratio = cast(double)counter_ / iterations_;
		auto header = appender!string();

		header.formattedWrite("%s %3d%% |", "Processing", cast(int)(ratio * 100));

		clear();
		write(getProgressBarText(header.data));
	}

public:
	this(size_t iterations)
	{
		if(iterations <= 0)
		{
			iterations = 1;
		}

		counter_ = 0;
		width_ = getTerminalWidth();
		this.iterations_ = iterations;
	}

	override void update(immutable string fileName)
	{
		clear();
		counter_++;

		if(counter_ > iterations_)
		{
			counter_ = iterations_;
		}

		updateProgressBar();
		stdout.flush();
	}

private:
	immutable static size_t defaultWidth_ = 80;
	size_t maxWidth_ = 40;
	size_t width_ = defaultWidth_;
	size_t iterations_;
	size_t counter_;
}

class ProgressText : Progress
{
	override void update(immutable string fileName)
	{
		clear();
		write(fileName);
		stdout.flush();
	}
}

Progress getProgressObject(size_t iterations)
{
	version(Windows)
	{
		return new ProgressText;
	}
	else
	{
		return new ProgressBar(iterations);
	}
}

