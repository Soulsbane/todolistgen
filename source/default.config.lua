TodoTaskPatterns = {
	["([A-Z]+):(.*)"] = false,
	["\\W+([a-zA-Z]+):\\s+(.*)"] = false,
	["\\W+(INFO|NOTE|FIXME|TODO):\\s+(.*)"] = false,
	["[;'#-*@/]*\\s*(INFO|NOTE|FIXME|TODO|XXX):?\\s*(.*)"] = true,
}
