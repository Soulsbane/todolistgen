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

		immutable static size_t default_width = 80;
		size_t max_width = 40;
		size_t width = default_width;

		size_t iterations;
		size_t counter;

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
				column = default_width;
			}

			return column;
		}


		void clear()
		{
			write("\x1B[2K");
			write("\r");
		}

		string progressbarText(string header_text)
		{
			immutable auto ratio = cast(double)counter / iterations;
			string result = "";
			double bar_length = width - header_text.length;

			if(bar_length > max_width && max_width > 0)
			{
				bar_length = max_width;
			}

			size_t i = 0;

			for(; i < ratio * bar_length; i++)
			{
				result ~= "o";
			}

			for(; i < bar_length; i++)
			{
				result ~= " ";
			}

			return header_text ~ result;
		}

		void print()
		{
			immutable auto ratio = cast(double)counter / iterations;
			auto header = appender!string();

			header.formattedWrite("%s %3d%% |", "Processing", cast(int)(ratio * 100));

			clear();
			write(progressbarText(header.data));
		}

	public:

		this(size_t iterations)
		{
			if(iterations <= 0)
			{
				iterations = 1;
			}

			counter = 0;
			width = getTerminalWidth();
			this.iterations = iterations;
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
				counter++;
				if(counter > iterations) counter = iterations;
				print();
			}

			stdout.flush();
		}
}

