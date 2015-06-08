module progressbar;

import std.stdio;
import std.range;
import std.format;
import std.datetime;
import core.sys.posix.unistd;
import core.sys.posix.sys.ioctl;

class ProgressBar
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


	void clear()
	{
		write("\x1B[2K");
		write("\r");
	}

	string getProgressbarText(immutable string headerText)
	{
		immutable auto ratio = cast(double)counter_ / iterations_;
		string result = "";
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
		write(getProgressbarText(header.data));
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

	void next(immutable string fileName)
	{
		clear();

		version(Windows)
		{
			write(fileName);
		}
		else
		{
			counter_++;

			if(counter_ > iterations_)
			{
				counter_ = iterations_;
			}

			updateProgressBar();
		}

		stdout.flush();
	}

private:
	immutable static size_t defaultWidth_ = 80;
	size_t maxWidth_ = 40;
	size_t width_ = defaultWidth_;

	size_t iterations_;
	size_t counter_;
}

