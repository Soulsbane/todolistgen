import std.stdio;
import std.path;
import std.file;

import api.path;

void extractFiles()
{
	immutable string[string] data =
	[
		"apitest/apitest.lua" : import("apitest/apitest.lua"),
		"apitest/data.txt" : import("apitest/data.txt"),

		"csv/csv.lua" : import("csv/csv.lua"),
		"html/html.lua" : import("html/html.lua"),

		"html/modules/etlua.lua" : import("html/modules/etlua.lua"),
		"html/templates/default/content.html" : import("html/templates/default/content.html"),
		"html/templates/default/footer.html" : import("html/templates/default/footer.html"),
		"html/templates/default/header.html" : import("html/templates/default/header.html"),
		"html/templates/default/default.css" : import("html/templates/default/default.css"),
		"html/templates/default/tasks.elt" : import("html/templates/default/tasks.elt"),

		"json/json.lua" : import("json/json.lua"),
		"markdown/markdown.lua" : import("markdown/markdown.lua"),
		"stdout/stdout.lua" : import("stdout/stdout.lua"),
		"xml/xml.lua" : import("xml/xml.lua")
	];

	debug
	{}
	else
	{
		foreach(dirString, importString; data)
		{
			string pathStr = dirName(buildNormalizedPath(getBaseAddonDir(), dirString));
			string fileName = buildNormalizedPath(getBaseAddonDir(), dirString);

			writeln(pathStr);
			writeln(fileName);

			if(!exists(pathStr))
			{
				mkdirRecurse(pathStr);
			}

			auto file = File(fileName, "w");
			file.write(importString);
		}
	}
}
