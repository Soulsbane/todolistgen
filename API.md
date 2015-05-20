#AppConfig.GetValue(name)
Retrieves the value of name's key in AppConfigVars table found in config.lua.

#FileReader.ReadText(fileName)
Reads text fileName and returns  the results as a string.

#FileReader.GetLines(fileName)
Returns a table constructed from each line in fileName.

#FileUtils.CopyFileTo(source, destination)
Copies a file from source to destination.

#FileUtils.CopyFileToOutputDir(fileName)
Copies fileName to the todo list output directory.

#FileUtils.GetDefaultTodoFileName()
Returns the fileName used to generate a todo list. By default this file is named todo. This setting is stored in config.lua in the AppConfigVars table.

#FileUtils.RemoveFileFromAddonDir(fileName)
Removes fileName from the currently in use addon's directory.

#FileUtils.RemoveFileFromOutputDir(fileName)
Removes fileName from the todo list output directory.

#Path.GetInstallDir()
Returns the directory where todolistgen is installed

#Path.GetBaseAddonDir()
Returns the path to addon directory.

#Path.GetAddonDir()
Returns the path to the currently in use addon's directory.

#Path.GetAddonModuleDir()
Returns the path to the currently in use addon's module directory.

#Path.GetModuleDir()
Returns the path to the module directory found in the install directory.

#Path.GetOutputDir()
Returns the path where the todo list will be created.

#Path.GetConfigDir()
Returns the path to the applications's config directory. On Linux /home/user/.config/Raijinsoft/todolistgen

#Path.Normalize(...)
Combines one or more path segments. Directory separators are inserted between segments if necessary. For example, passing Normalize("foo", "bar", "baz") will return "foo/bar/baz".


