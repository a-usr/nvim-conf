local sign = vim.fn.sign_define

sign("DapBreakpointCondition", {
  text = "",
  texthl = "Breakpoint",
})

sign("DapLogPoint", {
  text = "",
  texthl = "Breakpoint",
})

sign("DapBreakpoint", {
  text = "",
  texthl = "Breakpoint",
})

sign("DapBreakpointRejected", {
  text = "",
  texthl = "Breakpoint",
})

sign("DapStopped", {
  text = " ",
  texthl = "DapStopped",
})
