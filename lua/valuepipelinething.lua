---@generic Type
---@param a table
---@param b Type
---@return Type
local function derive(a, b)
	return setmetatable(a, { __index = b })
end

---@class PipelineValue<TValue>: {getValue: fun(self: self): TValue}
local PipelineValue = {}

---@param getValue fun(self): TValue
---@return PipelineValue<TValue>
function PipelineValue.new(getValue)
	return derive({ getValue = getValue }, PipelineValue)
end

---@class StaticValue<TValue> : PipelineValue<TValue>
local StaticValue = {}

---@param value TValue
---@return StaticValue<TValue>
function StaticValue.new(value)
	local _tmp = PipelineValue.new(function(_)
		return value
	end)
	return _tmp
end

---@alias callback<TValue> (fun(value: TValue))

---@class ReactiveValue<TValue>: PipelineValue<TValue>, { value: TValue, callbacks: callback[] }
local ReactiveValue = derive({}, PipelineValue)

---@param value TValue
---@return ReactiveValue<TValue>
function ReactiveValue.new(value)
	local Value = { value = value }
	return derive(Value, ReactiveValue)
end

function ReactiveValue:getValue()
	return self.value
end

---@param callback callback
---@return TValue
function ReactiveValue:getReactive(callback)
	self.callbacks = self.callbacks or {}
	table.insert(self.callbacks, callback)

	return self:getValue()
end

---@param newvalue TValue
function ReactiveValue:update(newvalue)
	self.value = newvalue

	---@type callback[]
	self.callbacks = self.callbacks or {}
	for _, cb in ipairs(self.callbacks) do
		cb(newvalue)
	end
end

---@class ReactiveJoin<TFirst, TSecond>: ReactiveValue<{ [1]: TFirst, [2]: TSecond }>
local ReactiveJoin = derive({}, ReactiveValue)

function ReactiveJoin.getReactive(callback)

---@generic TSecond
---@param second ReactiveValue<TSecond>
---@return ReactiveJoin<TValue,TSecond>
function ReactiveValue:join(second)
	local value = derive({value = {self.value, second}}, ReactiveJoin)

end
