import std.stdio;
import std.path;
import std.file: exists, mkdirRecurse;
import std.algorithm;
import std.array;
import std.typetuple;

import api.path;

enum fileNames =
[
	"apitest/apitest.lua",
	"apitest/data.txt",
	"csv/csv.lua",
	"html/html.lua",
	"html/modules/etlua.lua",
	"html/templates/default/content.html",
	"html/templates/default/footer.html",
	"html/templates/default/header.html",
	"html/templates/default/default.css",
	"html/templates/default/tasks.elt",
	"json/json.lua",
	"markdown/markdown.lua",
	"stdout/stdout.lua",
	"xml/xml.lua"
];

// Really cool trick learned from reggae* source code. D really is awesome!
// * https://github.com/atilaneves/reggae/blob/master/src/reggae/reggae.d
private string filesTupleString() @safe pure nothrow
{
	return "TypeTuple!(" ~ fileNames.map!(a => `"` ~ a ~ `"`).join(",") ~ ")";
}

template FileNames()
{
    mixin("alias FileNames = " ~ filesTupleString ~ ";");
}

void extractFiles()
{
	debug
	{}
	else
	{
		foreach(name; FileNames!())
		{
			immutable string filePath = dirName(buildNormalizedPath(getBaseAddonDir(), name));
			immutable string pathWithFileName = buildNormalizedPath(getBaseAddonDir(), name);

			if(!exists(filePath))
			{
				mkdirRecurse(filePath);
			}

			if(!exists(pathWithFileName))
			{
				auto fileHandle = File(pathWithFileName, "w");
				fileHandle.write(import(name));
			}
		}
	}
}
