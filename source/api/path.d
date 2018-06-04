module api.path;

import std.file;
import std.path;
import std.algorithm.searching : canFind;

import luaaddon.addonpaths;
import dfileutils;
import dpathutils;
import dtypeutils.singleton;

import constants;

class ApplicationPaths : AddonPaths
{
	mixin Singleton!ApplicationPaths;

	this() {}

	/**
		Initialize the paths with addonName

		Params:
			addonName = Name of the addon.
	*/
	this(const string addonName)
	{
		super(addonName, APPLICATION_NAME, ORGANIZATION_NAME);
	}

	/**
		Initialize the paths with addonName

		Params:
			addonName = Name of the addon.
	*/
	void create(const string addonName)
	{
		super.create(addonName, APPLICATION_NAME, ORGANIZATION_NAME);
	}

	/**
		Directory where files will be written to.

		Returns:
			The path to the directory to write file to.
	*/
	string getOutputDir()
	{
		return buildNormalizedPath(getcwd());
	}

	bool createDirInGeneratorDir(const(char)[][] params...)
	{
		immutable string path = buildNormalizedPath(params);
		return ensurePathExists(buildNormalizedPath(getBaseAddonDir(), path));
	}

	bool createDirInOutputDir(const(char)[][] params...)
	{
		immutable string path = buildNormalizedPath(params);
		return ensurePathExists(buildNormalizedPath(getOutputDir(), path));
	}

	void createOutputFile(const string fileName, const string data)
	{
		if(fileName.canFind(dirSeparator))
		{
			ensurePathExists(getOutputDir(), dirName(fileName));
		}

		immutable string outputFileName = buildNormalizedPath(getOutputDir(), fileName);
		ensureFileExists(outputFileName, data);
	}

	/**
		Remove a directory from the output directory.

		Params:
			dir = Name of the directory to remove.

		Returns:
			True if the directory exists false otherwise.
	*/
	bool removeDirFromOutputDir(const string dir)
	{
		return removePathIfExists(getOutputDir(), dir);
	}

	/**
		Determines of a directory can be found in the output directory.

		Params:
			dir = Name of the directory to remove.

		Returns:
			True if the directory exists false otherwise.

	*/
	bool outputDirExists(const string dir)
	{
		string file = buildNormalizedPath(getOutputDir(), dir);
		return file.exists;
	}

	/**
		Copy a file from one location to another.

		Params:
			from = File that should be copied.
			to = location where the file should be copied to.
	*/
	void copyFileTo(string from, string to) @trusted
	{
		copy(from, to, PreserveAttributes.yes);
	}

	/**
		Copy a file to the output directory.

		Params:
			fileName = File that should be copied.
	*/
	void copyFileToOutputDir(string fileName) @trusted
	{
		copy(fileName, buildNormalizedPath(getcwd(), baseName(fileName)), PreserveAttributes.yes);
	}

	/**
		Remove a file from an addon directory.

		Params:
			fileName = Name of the file to remove.
	*/
	void removeFileFromAddonDir(string fileName) @trusted
	{
		string file = buildNormalizedPath(getAddonDir(), fileName);

		if(file.exists)
		{
			remove(file);
		}
	}

	/**
		Remove a file from the output directory.

		Params:
			fileName = Name of the file to remove.
	*/
	void removeFileFromOutputDir(string fileName) @trusted
	{
		string file = buildNormalizedPath(getOutputDir(), fileName);

		if(exists(file))
		{
			remove(file);
		}
	}

	/**
		Returns the name of the base addon directory.

		Returns:
			The name of the base addon directory.
	*/
	override string getAddonDirName()
	{
		return "generators";
	}

	/**
		Registers a file for removal that will be removed after all addons have been destoyed.

		Params:
			fileName = Name of the file to remove.
	*/
	void registerFileForRemoval(string fileName)
	{
		remover_.add(fileName);
	}

private:
	FileRemover remover_;
}
