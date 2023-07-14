local M = {}

local parser = require "gotest.parser"
local lastrun  = require("gotest.lastrun")
local Job = require'plenary.job'
local Notify = require("notify")
local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" } -- spinners


local function update_notfication(notification) 

end

local function run(testname, path)
  local notification
  local title = testname
  local spinner_frame = 1

  local notify_output = vim.schedule_wrap(function(title, data)
    spinner_frame = (spinner_frame + 1) % #spinner_frames

    local notif_conf = {
        icon = spinner_frames[spinner_frame],
        title = title,
        render = "compact",
        timeout = false,
        hide_from_history = true,
    }

    if notification then
      notif_conf.replace = notification
    end


    notification = Notify(data, nil, notif_conf)

    -- local timer = vim.loop.new_timer()
    -- vim.defer_fn(function()
    --   notify_output(title, data)
    -- end, 100)
  end)


  if testname == "" then
    args = { 'test', '-coverprofile='..lastrun.coveragefile, './...'}
    title = parser.get_module_name()
  else
    args = { 'test', '-count=1', '-v', '-coverprofile='..lastrun.coveragefile, '-run', '^' .. testname .. '$', path}
  end

  vim.api.nvim_buf_set_lines(lastrun.popup.bufnr, 0, -1, false, {})

  Job:new({
    command = 'go',
    args = args,
    cwd = path,
    on_stdout = vim.schedule_wrap(function(_, data)
      vim.api.nvim_buf_set_lines(lastrun.popup.bufnr, -1, -1, true, { data })
    end),
    on_stderr = vim.schedule_wrap(function(_, data)
      vim.api.nvim_buf_set_lines(lastrun.popup.bufnr, -1, -1, true, { data })
    end),
    on_exit = function(j, return_val)
      local level = "success"
      local icon = ""

      if return_val ~= 0 then
        level = "error"
        icon = ""
      end

      notification = Notify(data, level, {
        title = "Finished",
        render = "compact",
        icon = icon,
        timeout = 3000,
        hide_from_history = false,
        replace = notification,
      })

      lastrun.path = path
      lastrun.testname = testname
      lastrun.return_val = return_val
      lastrun.result = j:result()

    end,
  }):start() -- sync() -- or start()

  notify_output("Test Running", title)
end

M.clean_last_run = function() 
  lastrun.path = ""
  lastrun.testname = ""
  lastrun.return_val = 0
  lastrun.result = {}
  vim.api.nvim_buf_set_lines(lastrun.popup.bufnr, 0, -1, false, {})
end

M.run_last_test = function ()
  if lastrun.testname == "" then
    local path = vim.fn.expand('%:p:h')
      run("", path)
    return
  end

  run(lastrun.testname, lastrun.path)
end

M.run_test = function ()
  local testname = parser.get_function_name()
  local path = vim.fn.expand('%:p:h')
  local filename = vim.fn.expand('%:t')

  if testname == "" then
    M.run_last_test()
    return
  end

  run(testname, path)
end

M.show_last_test_result = function ()
  lastrun.popup:show()
end

return M


