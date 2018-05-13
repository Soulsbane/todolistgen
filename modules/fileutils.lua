local FileUtils = FileUtils

local function slice(arr, first, last)
	local sub = {}

	for i = first, last do
		sub[#sub + 1] = arr[i]
	end

	return sub
end

function FileUtils.CreateTodoFile(fileExt)
	return IO.CreateTodoFile(fileExt)
end

return FileUtils
