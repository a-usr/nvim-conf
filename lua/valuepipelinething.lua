---@generic Type
---@param a table
---@param b Type
---@return Type
local function derive(a, b)
	return setmetatable(a, { __index = b })
end

---@alias Callback<T> fun(value: T)

---@class PipelineValue<TValue>
---@field getValue fun(self, callback?: Callback<TValue> ): TValue
local PipeVal = {}

---@param getValue fun(self, callback?: Callback<TValue>): TValue
---@return PipelineValue<TValue>
function PipeVal.new(getValue)
	return derive({ getValue = getValue }, PipeVal)
end

---@class StaticValue<TValue> : PipelineValue<TValue>
local SVal = {}

---@generic TValue
---@param value TValue
---@return StaticValue<TValue>
function SVal.new(value)
	local _tmp = PipeVal.new(function(_)
		return value
	end)
	return _tmp
end

---@class ReactiveValue<TValue>: PipelineValue<TValue>
---@field callbacks Callback<TValue>
---@field value TValue
local RVal = derive({}, PipeVal)

---@generic TValue
---@param value TValue
---@return ReactiveValue<TValue>
function RVal.new(value)
	local Value = { value = value }
	return derive(Value, RVal)
end

function RVal:getValue(callback)
	self.callbacks = self.callbacks or {}
	table.insert(self.callbacks, callback)

	return self.value
end

---@param newvalue TValue
function RVal:update(newvalue)
	self.value = newvalue

	---@type callback[]
	self.callbacks = self.callbacks or {}
	for _, cb in ipairs(self.callbacks) do
		cb(newvalue)
	end
end

---@class ReactiveJoin<TFirst, TSecond>: ReactiveValue<{ [1]: TFirst, [2]: TSecond }>
local RJoin = derive({}, RVal)

---@generic TSecond
---@param second PipelineValue<TSecond>
---@return ReactiveJoin<TValue,TSecond>
function PipeVal:join(second)
	local base = self
	local cbinitialized = false
	local val = derive({}, RJoin)

	function val:getValue(callback)
		if callback ~= nil then
			self.callbacks = self.callbacks or {}
			table.insert(self.callbacks, callback)
			if not cbinitialized then
				cbinitialized = true
				self.value = {
					base:getValue(function(fval)
						self:update({ fval, self.value[2] })
					end),
					second:getValue(function(secval)
						self:update({ self.value[1], secval })
					end),
				}
			end
		else
			self.value = { base:getValue(), second:getValue() }
		end
		return self.value
	end

	return val
end

function PipeVal:map() end
