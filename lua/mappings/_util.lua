---@module "which-key"

---@class mapping.proto: wk.Spec
---@field [2]? string|fun()|mapping.proto[] rhs/submap
---@field submap? mapping.proto[]
local mappingProto = {}

local M = {}

---map stuff
---@param proto mapping.proto
---@return wk.Spec[]
function M:Map(proto)
  local submaps = proto.submap

  local _submaps = proto[2] -- for some reason casting proto[2] directly changes proto[1] to possibly be `2`
  if type(_submaps) ~= "function" and type(_submaps) ~= "string" then
    ---@cast _submaps mapping.proto[]
    submaps = _submaps
  end

  local maps = {} ---@type wk.Spec[]

  -- check wether the current prototype is a group and insert the respective keybind
  if proto.group then
    local groupBind = {} ---@type wk.Spec
    groupBind[1] = proto[1]

    groupBind.group = proto.group
    groupBind.icon = proto.icon
    table.insert(maps, groupBind)
  end

  --handle submaps
  if submaps then
    for _, submap in pairs(submaps) do
      local map = M:Map(submap)
      for _, bind in pairs(map) do
        bind[1] = proto[1]..bind[1]
        table.insert(maps, bind)
      end
    end
  end

  return maps
end
