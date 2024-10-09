local libmodalMode = require("libmodal").mode
local M = {}

---split the lhs
---@param lhs string
---@return table
function M.split_lhs(lhs)
  local list = {}
  local buffer = ""
  for char in lhs:gmatch(".") do
    if char ~= "<" and buffer == "" then
      table.insert(list, char)

    else
      if char == ">" then
        table.insert(list, buffer..char)
        buffer = ""

      else
        buffer = buffer..char
      end

    end
  end
  assert(buffer == "", "Incomplete Special Character! Found '"..buffer.."'")
  return list
end

---map a keybind
---@param tbl table
---@param nvimmode string
---@param lhs string
---@param rhs string | function
---@param _? string Description
function M:map(tbl, nvimmode, lhs, rhs, _)
  if not tbl[nvimmode] then
    tbl[nvimmode] = {}
  end
  local lastlastMap = tbl
  local lastKey = nvimmode
  local keys = M.split_lhs(lhs)
  for _, key in ipairs(keys) do


    if not lastlastMap[lastKey][key] then
      lastlastMap[lastKey][key] = {}
    end

    lastlastMap = lastlastMap[lastKey]
    lastKey = key
  end

  lastlastMap[lastKey] = rhs
end

--- @class modes.Mode
--- @field name string
--- @field keymap table
--- @field mode libmodal.Mode
local mode = { }

M.Mode = {}

---comment
---@param modename string
---@return modes.Mode 
function M.Mode.new(modename)
  local o = setmetatable({ name = modename, keymap = {} }, mode)
  mode.__index = mode
  return o
end

---Map a keybind
---@param lhs string Key Combo
---@param rhs string|function Action
---@param _? string Description
function mode:map(lhs, rhs, _)
  self.keymap[lhs] = rhs
end


---Map keybind beginning with <leader>
---@param lhs string
---@param rhs string | function
---@param _? string Description
function mode:mapleader(lhs, rhs, _)
  self:map("<leader>"..lhs, rhs, _)
end

---Enter the Mode. This Function blocks until the Mode is exited
function mode:enter()
  libmodalMode.enter(self.name, self.keymap)
end


return M
