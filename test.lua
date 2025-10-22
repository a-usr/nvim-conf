local M = {}

function M:__index(idx)
	print("a")
	return "b"
end
M = setmetatable(M, M)
print(M.a)
