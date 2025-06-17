local function imp(path)
  return { import = "languages." .. path .. ".plugins" }
end

local langs_path = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":r")
local langs = vim.fn.readdir(langs_path)

local enabled_languages = { "cs", "lua", "python", "rust", "webdev" }

local filtered_languages = vim.tbl_filter(function(el)
  return vim.tbl_contains(langs, el)
end, enabled_languages)

local plugin_imports = {}

for _, lang in ipairs(filtered_languages) do
  local lang_dir = langs_path .. "/" .. lang
  if vim.iter(vim.fs.dir(lang_dir)):any(function(name, _)
    return name:match "plugins"
  end) then
    table.insert(plugin_imports, imp(lang))
  end
  ---@type string[]
  local files = vim
    .iter(vim.fs.dir(lang_dir))
    :filter(function(name, type)
      return type == "file" and not name:match "plugins"
    end)
    :map(function(name, _)
      return name
    end)
    :totable()
  for _, file in ipairs(files) do
    vim.schedule(function()
      pcall(require, "languages." .. lang .. "." .. file:sub(1, -5))
    end)
  end
end

-- Snacks.debug(plugin_imports)
return plugin_imports
