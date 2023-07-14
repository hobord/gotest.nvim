local coveragefile = vim.fn.tempname()
local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event

local  popup = Popup({
    enter = true,
    focusable = true,
    relative = "editor",
    border = {
      style = "rounded",
    },
    position = "50%",
    size = {
      width = "80%",
      height = "60%",
    },
  })

popup:mount()
popup:hide()

popup:on(event.BufLeave, function()
  popup:hide()
end)

local M = {
  path = "",
  testname = "",
  return_val = 0,
  result = {},
  coveragefile = coveragefile,
  popup = popup,
}

return M
