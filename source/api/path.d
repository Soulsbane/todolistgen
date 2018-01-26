module api.path;

import std.file : exists, getcwd, thisExePath;
import std.path : dirName, buildNormalizedPath;

import luaaddon.addonpaths;
import dfileutils;
import dpathutils;

import inputcollector;
import config;

class ApplicationPaths : AddonPaths
{

	this(const string addonName)
	{
		super(addonName, APPLICATIONNAME, ORGANIZATIONNAME);
	}

	string getOutputDir()
	{
		return buildNormalizedPath(getcwd(), getValueFor("ProjectName"));
	}

	bool createDirInOutputDir(const(char)[][] params...)
	{
		immutable string path = buildNormalizedPath(params);
		return ensurePathExists(buildNormalizedPath(getOutputDir(), path));
	}

	bool removeDirFromOutputDir(const string dir)
	{
		return removePathIfExists(getOutputDir(), dir);
	}

	bool outputDirExists(const string dir)
	{
		string file = buildNormalizedPath(getOutputDir(), dir);
		return file.exists;
	}
}
