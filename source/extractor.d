module extractor;

import api.path;
import dfileutils.extractor;

enum generatorFilesList =
[
	"apitest/apitest.lua",
	"apitest/data.txt",
	"csv/csv.lua",
	"html/html.lua",
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
	"appconfig.lua",
	"fileutils.lua",
	"ansicolors.lua",
	"globals.lua",
	"etlua.lua"
];

void extractGenerators()
{
	debug
	{}
	else
	{
		extractImportFiles!generatorFilesList(_AppPaths.getBaseAddonDir(), Yes.overwrite);
		extractImportFiles!moduleFilesList(_AppPaths.getModuleDir(), Yes.overwrite);
	}
}
