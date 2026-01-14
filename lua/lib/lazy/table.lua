local M = {}

---@generic T
---@param tbl T
---@return T
function M.inheritRecursive(tbl)
	return setmetatable({}, {
		__index = function(self, key)
			local value = tbl[key]
			if type(value) == "table" then
				value = M.inheritRecursive(value)
			end
			self[key] = value
			return value
		end,
	})
end

local function regularget(t, k)
	return t[k]
end

local function first(v, ...)
	return v
end

---@generic T: table
---@param get fun(t: table, k: string): any
---@param key string
---@param first_table T?
---@param ... T
---@return table?
local function findAllValues(get, key, first_table, ...)
	if first_table == nil then
		return nil
	end
	local value = get(first_table, key)

	if value == nil then
		return findAllValues(get, key, ...)
	end

	local nextval = findAllValues(get, key, ...)

	if type(value) == "table" and nextval ~= nil then
		if nextval[1] ~= nil then
			assert(
				type(nextval[1]) == "table",
				"Encountered non-table item while merging tables: " .. tostring(nextval)
			)
		end

		return { value, unpack(nextval) }
	else
		return { value }
	end
end

--- Snacks.debug(
--- 	findAllValues(
--- 		rawget,
--- 		"a",
--- 		{ a = { x = "1" }, c = "d" },
--- 		{ h = "a", a = { y = 2 }, f = "s" },
--- 		{ a = { 6, 23, "a" } }
--- 	)
--- )

--- Merge tables recursively. Duplicate keys with non-table values are treated fifo. Due to their nature, list values will be combined too.
---@generic T: table
---@param ... T
---@return T
function M.mergeRecursively(...)
	-- Has to be packed because varargs dont transfer into inner function scopes
	local tables = { ... }
	return setmetatable({}, {
		source = tables,
		__index = function(t, k)
			-- pack all return values
			local value = findAllValues(rawget, k, unpack(tables))
			assert(value ~= nil)
			if value[1] == nil then
				value = findAllValues(regularget, k, unpack(tables))
				assert(value ~= nil)
			end

			if type(value[1]) == "table" then
				value = M.mergeRecursively(unpack(value))
			else
				value = value[1]
			end
			t[k] = value
			return value
		end,
	})
end

--- local testvalue = M.mergeRecursively(
--- 	{ a = 1, l = false, b = { c = 2, d = { 2, 2, 1, 2 } } },
--- 	{ a = 3, b = { e = 1, d = { x = 4 }, f = "deez" }, h = true }
--- )
--- 
--- local _ = testvalue.b.c
--- local _ = testvalue.b.d
--- local _ = testvalue.b.e
--- Snacks.debug(testvalue)

---@return int ...
local function a()
	return 1, 2, 3
end

return M
