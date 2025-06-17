local coro = coroutine

---@type {waiters: thread[], value: any}[]
local modules = {}

---@class lib.lazy.context
---@field co thread
local context_mt = {}
context_mt.__index = context_mt

---@async
---@param module string
---@return any
function context_mt:await(module)
  if modules[module] then
    local m_item = modules[module]

    if m_item.value then
      return m_item.value
    end

    table.insert(m_item.waiters, self.co)
  else
    modules[module] = { waiters = { self.co }, value = nil }
  end
  return coro.yield()
end

local M = {}

---@param f fun(ctx: lib.lazy.context )
function M.wrap(f)
  local co = coro.create(f)

  local context = { co = co }
  setmetatable(context, context_mt)

  coroutine.resume(co, context)
end

---@param module string
---@param value any
function M.notify(module, value)
  if modules[module] then
    local m_val = modules[module]
    m_val.value = value
    for _, co in ipairs(m_val.waiters) do
      coro.resume(co, value)
    end
  else
    modules[module] = { waiters = {}, value = value }
  end
end

function M.notify_module(module)
  M.notify(module, require(module))
end

return M
