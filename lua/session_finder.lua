-- For the most part exactly the telescope finder from Persisted, but like, different

local function escape_pattern(str, pattern, replace, n)
  pattern = string.gsub(pattern, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1") -- escape pattern
  replace = string.gsub(replace, "[%%]", "%%%%") -- escape replacement

  return string.gsub(str, pattern, replace, n)
end

local M = {}

function M.find()
  local sep = require("persisted.utils").dir_pattern()

  local sessions = {}
  for _, session in pairs(require("persisted").list()) do
    local session_name = escape_pattern(session, require("persisted.config").save_dir, "")
      :gsub("%%", sep)
      :gsub(vim.fn.expand "~", sep)
      :gsub("//", "")
      :sub(1, -5)

    if vim.fn.has "win32" == 1 then
      session_name = escape_pattern(session_name, sep, ":\\", 1)
      session_name = escape_pattern(session_name, sep, "\\")
    end

    local branch, dir_path

    if string.find(session_name, "@@", 1, true) then
      local splits = vim.split(session_name, "@@", { plain = true })
      branch = table.remove(splits, #splits)
      dir_path = vim.fn.join(splits, "@@")
    else
      dir_path = session_name
    end

    table.insert(sessions, {
      text = session_name,
      session = session,
      ["branch"] = branch,
      file = dir_path,
      dir = dir_path,
    })
  end
  return sessions
end

function M.format(item)
  local no_icons = {
    selected = "",
    dir = "",
    branch = "",
  }
  local icons = vim.tbl_extend("force", no_icons, require("persisted.config").telescope.icons or {})

  local final = {}

  local function append(str, hl)
    if hl then
      table.insert(final, { str, hl })
    else
      table.insert(final, { str })
    end
  end

  -- is current session
  append(item.session == vim.v.this_session and (icons.selected .. " ") or "   ", "PersistedTelescopeSelected")

  -- session path
  append(icons.dir, "PersistedTelescopeDir")
  append(item.file)

  -- branch
  if item.branch then
    append(" " .. icons.branch .. item.branch, "PersistedTelescopeBranch")
  end

  return final
end
return M
