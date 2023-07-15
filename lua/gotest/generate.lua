local M = {}
-- gotests -w -only ^CreateServices$ /Users/balazs/code/cmp-main/services/flexsave/gcp/cmd/api/services.go
local parser = require "gotest.parser"
local Job = require'plenary.job'

M.genereate_function_test = function()
  local testname = parser.get_function_name()
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
        return
      end

      local test_filename = filename:gsub(".go", "_test.go")

      vim.defer_fn(function()
        vim.api.nvim_command("edit " .. path .. "/" .. test_filename)
        local last_line = vim.api.nvim_buf_line_count(0)
        local lines = vim.api.nvim_buf_get_lines(0, 0, last_line, false)

        for i, line in ipairs(lines) do
          if line:match("func Test" .. testname) then
            vim.api.nvim_win_set_cursor(0, {i, 0})
            test_line_number = i
            break
          end
        end

      end, 100)
    end,
  }):start() -- sync() -- or start()
end


return M;
