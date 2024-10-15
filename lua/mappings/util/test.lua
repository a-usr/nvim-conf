return function(target)
  local util = require "mappings.util"
  local mapping = target and require(target)
    or util.Map {
      "<leader>",
      {
        "f",
        group = "smth",
        {
          "a",
          "do smth",
          desc = "a",
        },
        {
          "b",
          "do smth else",
          desc = "b",
        },
      },
      {
        "c",
        "third thing",
        desc = "c",
        on = "startup",
      },
      {
        "k",
        mode = { "n", "v" },
        group = "chee",
        on = "LSP attach",
        {
          "d",
          "fourth thing",
          desc = "D",
        },
        {
          "q",
          {
            "e",
            "fifth thing",
            desc = "E",
          },
        },
      },
    }
  print(vim.inspect(mapping))
end
