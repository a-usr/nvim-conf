---@module "which-key"

---@alias mapping.mapEvent "startup"|"LSP attach"
---@alias mapping.proto.type "bind"|"group"

---@class mapping.proto: wk.Spec
---@field [1] string|mapping.proto
---@field [2]? string|fun()|mapping.proto rhs/submap
---@field [number]? mapping.proto
---@field mode? VimKeymapMode|VimKeymapMode[]
---@field on? mapping.mapEvent
---@field type? mapping.proto.type
local mappingProto = {}

local M = {}

---Makes a mapping.proto partially compatible with wk.Spec, by putting non-numbered attributes into a metatable
---@param proto mapping.proto
---@return mapping.proto
local function mkWkSpecCompatible(proto)
  local metatable = getmetatable(proto) or {}
  metatable.__index = metatable
  metatable.type = proto.type
  proto.type = nil

  metatable.on = proto.on
  proto.on = nil

  return setmetatable(proto, metatable)
end

local function normalize(proto, lead)
  if type(proto[1]) == "string" then -- Regular bind
    proto[1] = lead .. proto[1]
  else -- group
    for k, km in pairs(proto) do
      if type(k) == "number" then
        normalize(km, lead)
      end
    end
  end
end
---map stuff
---@param proto mapping.proto
---@return mapping.proto
function M.Map(proto)
  if type(proto[2]) ~= "table" and proto[2] then -- proto is a "normal" wk.Spec
    proto.type = "bind"
    return { mkWkSpecCompatible(proto) }
  end

  --inherit group stuff
  local prototmp = {}

  -- check wether the current prototype is a which-key group and insert the respective keybind
  if proto.group then
    assert(type(proto[1]) == "string", "groups need a common identifier!")
    local groupBind = { proto[1] } ---@type mapping.proto

    groupBind.group = proto.group
    groupBind.icon = proto.icon
    groupBind.type = "bind"
    table.insert(prototmp, mkWkSpecCompatible(groupBind))
    proto.group = nil
  end

  for index, sm in pairs(proto) do
    if type(sm) == "table" and type(index) == "number" then
      local map = M.Map(sm)
      local canFlatten = true

      for key, bind in pairs(map) do
        if type(proto[1]) == "string" and type(key) == "number" then
          normalize(bind, proto[1])
        end

        if type(key) ~= "number" then
          canFlatten = false
        end
      end

      if canFlatten then
        for _, v in pairs(map) do
          table.insert(prototmp, v)
        end
      else
        map.type = "group"
        table.insert(prototmp, mkWkSpecCompatible(map))
      end
    end
  end

  if type(proto[1]) == "string" then
    table.remove(proto, 1)
  end
  for i, km in pairs(prototmp) do
    proto[i] = km
  end
  proto.type = "group"
  return mkWkSpecCompatible(proto)
end

---Get Maps that should be mapped when "on" occurs
---@param on mapping.mapEvent
---@param maps mapping.proto[]
---@param strict? boolean
---@return wk.Spec
function M.GetMapsOn(on, maps, strict)
  if strict == nil then
    strict = true
  end

  local found = {}
  for key, map in pairs(maps) do
    if type(key) == "number" then
      if map.on == on or (strict == false and map.on == nil) then
        if map.type == "bind" then
          table.insert(found, map)
        else
          for _, v in pairs(M.GetMapsOn(on, map, false)) do
            table.insert(found, v)
          end
        end
      else
        if map.type == "group" then
          for _, v in pairs(M.GetMapsOn(on, map, true)) do
            table.insert(found, v)
          end
        end
      end
    end
  end

  local out = {}
  for _, match in pairs(found) do
    local copy = {}
    for k, v in pairs(maps) do
      if type(k) ~= "number" then
        copy[k] = v
      end
    end
    for k, v in pairs(match) do
      copy[k] = v
    end
    table.insert(out, copy)
  end
  return out
end

---Get Maps that should be mapped on startup
---@param maps mapping.proto[]
---@return wk.Spec[]
function M.GetMapsOnStartup(maps)
  return M.GetMapsOn("startup", maps, false)
end
return M
