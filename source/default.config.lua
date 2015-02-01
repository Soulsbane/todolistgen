TodoTaskPatterns = {
	["(?P<tag>[A-Z]+):(?P<message>.*)"] = false,
	["\\W+(?P<tag>[a-zA-Z]+):\\s+(?P<message>.*)"] = false,
	["\\W+(?P<tag>INFO|NOTE|FIXME|TODO):\\s+(?P<message>.*)"] = false,
	["[;'#-*@/]*\\s*(?P<tag>INFO|NOTE|FIXME|TODO|XXX):?\\s*(?P<message>.*)"] = true,
}
