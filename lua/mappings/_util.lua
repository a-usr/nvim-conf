

---@class mapping.proto: wk.Spec
---@field [2]? string|fun()|mapping.proto[] rhs/submap
---@field submap? mapping.proto[]
local mappingProto = {}

local M = {}

---map stuff
---@param proto mapping.proto
function M:Map(proto)
  local submaps = proto.submap
  if type(proto[2]) ~= "function" and type(proto[2]) ~= "string" then
    ---@cast proto[2] mapping.proto[]
    submaps = proto[2]
  end
  local maps = {} ---@type wk.Spec[]
  if proto.group then
    local groupmap = {} ---@type wk.Spec
    groupmap[1] = proto[1]

    groupmap.group = proto.group
    groupmap.icon = proto.icon
    table.insert(proto, groupmap)
  end
  if submaps then
    for _, submap in pairs(submaps) do
      local map = M:Map(submap)
    end
  end
end
