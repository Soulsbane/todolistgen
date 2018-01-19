module addonextractor;

import std.stdio;
import std.path;
import std.file: exists, mkdirRecurse;
import std.algorithm;
import std.array;
import std.typetuple;

import api.path;
import dfileutils.extractor;

enum generatorFilesList =
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

enum moduleFilesList =
[
];

void extractGenerators()
{
	debug
	{}
	else
	{
		ApplicationPaths paths; //FIXME: Will not compile. applicationpaths module doesn't exist

		extractImportFiles!generatorFilesList(paths.getBaseGeneratorDir());
		extractImportFiles!moduleFilesList(paths.getModuleDir());
	}
}
