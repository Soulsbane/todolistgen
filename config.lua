TodoTaskPattern = "([A-Z]+):(.*)"
ImprovedTodoTaskPattern = "\\W+([a-zA-Z]+):\\s+(.*)"
TodoTaskPatterns = {
	["([A-Z]+):(.*)"] = false,
	["\\W+([a-zA-Z]+):\\s+(.*)"] = true,
}
