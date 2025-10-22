---@class PipelineValue<TValue>: {_getValue: fun(self: PipelineValue<TValue>): TValue}
local PipelineValue = {}

---@generic TValue
---@param getValue fun(self): TValue
---@return PipelineValue<TValue>
function PipelineValue.new(getValue)
  return setmetatable({ _getValue = getValue }, PipelineValue)
end

---@class StaticValue<TValue> : PipelineValue<TValue>
local StaticValue = {}

---@generic TValue
---@param value TValue
---@return StaticValue<TValue>
function StaticValue.new(value)
  local _tmp = PipelineValue.new(function(_)
    return value
  end)
  ---@cast _tmp PipelineValue
  return _tmp
end

---@class ReactiveValue<TValue>: PipelineValue<TValue>, {_getReactive: fun(Self, callback: (fun(value: `TValue`)))}
local ReactiveValue = {}
setmetatable(ReactiveValue, PipelineValue)
