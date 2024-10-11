local M = {}

---@alias mappings.mapEvent "startup"|"LSP attach"

---@class mappings.util.mapping
---@field [1]? string
---@field description? string
---
---@field [2]? string
---@field lhs? string
---
---@field [3]? string|function
---@field rhs? string|function
---
---@field mode? VimKeymapMode|VimKeymapMode[]
---@field category? string
---@field icon? string
---@field highlight? string
---@field on? mappings.mapEvent


---@class mappings.mappingProto
---@field [1] string lhs
---@field [2] string|function rhs
---@field mode VimKeymapMode|VimKeymapMode[]
---@field opts vim.keymap.set.Opts
---@field menuName string
---@field menuHighlight string
---@field mapOn mappings.mapEvent
---@field group string
local mappingProto = {}
mappingProto.__index = mappingProto
---Converts this to a whichkey spec. This performs copy-ing
---@return { [1]: wk.Spec }
function mappingProto:ToWhickKeySpec()
  local excludedFields = { menuName=true, menuHighlight=true, mapOn = true }

  local spec = {}
  -- copy without opts
  for k, v in pairs(self) do
    if not excludedFields[k] then
      spec[k] = v
    end
  end


  return spec
end

---map a Keybinding
---@param mode VimKeymapMode|VimKeymapMode[]
---@param lhs string
---@param rhs string|function
---@param description string
---@param menuName? string
---@param highlight? string
---@param mapOn? mappings.mapEvent
---@return mappings.mappingProto
function M.map(mode, lhs, rhs, description, menuName, highlight, groupName, mapOn)
  return setmetatable({
    lhs,
    rhs,
    mode = mode,
    desc = description,
    menuName = menuName,
    menuHighlight = highlight,
    mapOn = mapOn or "startup",
    group = groupName,
  }, mappingProto)
end

---Map a Keybinding
---@param description string the description of the Binding
---@param mode VimKeymapMode|VimKeymapMode[] The mode
---@param lhs string the key combination
---@param rhs string|function the action to perform
---@param category? string the category it is displayed in in the cheatsheet
---@param icon? string the Icon the right-click menu will use
---@param highlight? string The highlight group for the right-click menu
---@param on? mappings.mapEvent When to map the keybind. Default is `"startup"`
function M.Map(description, mode, lhs, rhs, category, icon, highlight, on)
  category = category or ""
  icon = icon or ""
  return M.map(mode, lhs, rhs, description , icon.." "..description, highlight, category, on)
end

---Map a Keybinding in Normal mode
---@param description string the description of the Binding
---@param lhs string the key combination
---@param rhs string|function the action to perform
---@param category? string the category it is displayed in in the cheatsheet
---@param icon? string the Icon the right-click menu will use
---@param highlight? string The highlight group for the right-click menu
function M.MapN(description, lhs, rhs, category, icon, highlight)
  return M.Map(description, "n", lhs, rhs, category, icon, highlight)
end

---Map many keymaps
---@param maps mappings.util.mapping[]
---@return table
function M.MapMany(maps)
  local arr = {}

  for _, map in pairs(maps) do
    local desc = map.description or map[1] or ""
    local mode = map.mode or "n"
    local lhs = map.lhs or map[2] or error("Tried to create new keybind, but without a LHS!", 2)
    local rhs = map.rhs or map[3] or error("Tried to create new keybind, but without a RHS!", 2)
    table.insert(arr, M.Map(desc, mode, lhs, rhs, map.category, map.icon, map.highlight, map.on))
  end
  return arr
end

---Create a Keybind string beginning with the leader
---@param keys string The keys after the leader
---@return string A string containing `"<leader>"` followed by the `keys`
function M.L(keys)
  return "<leader>"..keys
end

return M
