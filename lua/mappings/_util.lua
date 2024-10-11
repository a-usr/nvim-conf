

---@class mapping.proto: wk.Spec
---@field [2]? string|fun()|mapping.proto[] rhs/submap
---@field submap? mapping.proto[]
local mappingProto = {}

local M = {}

function M:Map(proto)
  local submap = proto.submap
  if type(proto[2]) ~= "function" and type(proto[2]) ~= "string" then
    submap = proto[2]
  end
  if submap then
    
  end
end
