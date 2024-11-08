local python = {
  testing = {
    filePatterns = { "test_%.py" },
  },
}

require("neoconf.plugins").register {
  name = "neotest_python",
  on_schema = function(schema)
    schema:import("python", python)
    schema:set("python.testing.filePatterns", {
      description = "pytest cli arguments",
      anyOf = {
        { type = "array" },
      },
    })
  end,
}
