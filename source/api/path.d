module api.path;

import std.file;// : exists, getcwd, thisExePath;
import std.path;// : baseName, dirName, buildNormalizedPath;

import luaaddon.addonpaths;
import dfileutils;
import dpathutils;

import inputcollector;
import config;

class ApplicationPaths : AddonPaths
{

	this(const string addonName)
	{
		super(addonName, APPLICATION_NAME, ORGANIZATION_NAME);
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

	void copyFileTo(string from, string to) @trusted
	{
		copy(from, to, PreserveAttributes.yes);
	}

	void copyFileToOutputDir(string fileName) @trusted
	{
		copy(fileName, buildNormalizedPath(getcwd(), baseName(fileName)), PreserveAttributes.yes);
	}

	void removeFileFromAddonDir(string fileName) @trusted
	{
		string file = buildNormalizedPath(getAddonDir(), fileName);

		if(file.exists)
		{
			remove(file);
		}
	}

	void removeFileFromOutputDir(string fileName) @trusted
	{
		string file = buildNormalizedPath(getOutputDir(), fileName);

		if(exists(file))
		{
			remove(file);
		}
	}

	override string getAddonDirName()
	{
		return "generators";
	}


	void registerFileForRemoval(string fileName)
	{
		remover_.add(fileName);
	}

private:
	FileRemover remover_;
}
