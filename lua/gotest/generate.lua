local M = {}
-- gotests -w -only ^CreateServices$ /Users/balazs/code/cmp-main/services/flexsave/gcp/cmd/api/services.go
local parser = require "gotest.parser"
local Job = require'plenary.job'

M.genereate_function_test = function()
  local testname = parser.getFnName()
  local path = vim.fn.expand('%:p:h')
  local filename = vim.fn.expand('%:t')

  local args = {
    "-w",
    "-only",
    "^" .. testname .. "$",
    path .. "/" .. filename
  }

  Job:new({
    command = 'gotests',
    args = args,
    cwd = path,
    -- on_stdout = vim.schedule_wrap(function(_, data)
    --   vim.api.nvim_buf_set_lines(lastrun.popup.bufnr, -1, -1, true, { data })
    -- end),
    -- on_stderr = vim.schedule_wrap(function(_, data)
    --   vim.api.nvim_buf_set_lines(lastrun.popup.bufnr, -1, -1, true, { data })
    -- end),
    on_exit = function(j, return_val)
      if return_val ~= 0 then
      end
    end,
  }):start() -- sync() -- or start()
end


return M;
