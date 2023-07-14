local parser = require("gotest.parser")
local lastrun = require("gotest.lastrun")

local M = {}

M.hi = vim.api.nvim_create_namespace("goc")
M.clear_coverages = function(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr or 0, M.hi, 0, -1)
end

vim.api.nvim_set_hl(0, 'GocNormal', {link='Comment'})
vim.api.nvim_set_hl(0, 'GocCovered', {link='String'})
vim.api.nvim_set_hl(0, 'GocUncovered', {link='Error'})

M.show_coverage = function ()
  local lines = vim.fn.readfile(lastrun.coveragefile)
  local module_name = M.get_module_name()
        module_name = module_name:gsub("%-", "%%-")
        module_name = module_name:gsub("%.", "%%.")
        module_name = module_name:gsub("%+", "%%+")
        module_name = module_name:gsub("%?", "%%?")
  local module_path  = M.get_module_path()

  for i = 2,#lines do
    local line = lines[i]
    local path = string.gmatch(line, '(.+):')()
    local parts = vim.split(line, ":")

    local fullPathFile = module_path .. "/" .. parts[1]:gsub(module_name .. "/", "")
    -- print ("module_name: " .. module_name)
    -- print ("fullPathFile: " .. fullPathFile)
    local bufnr = vim.fn.bufnr(fullPathFile)
    if bufnr == -1 then
      print("no buffer for file: " .. fullPathFile)
      return
    end
    -- for i = 0,vim.fn.line('$') do
    --   vim.api.nvim_buf_add_highlight(bufnr, M.hi, "GocNormal", i, 0, -1)
    -- end

    print ("parts[2]: " .. parts[2])
    local marks = string.gmatch(parts[2], '%d+')

    print("marks: " .. vim.inspect(marks))

    local startline = math.max(tonumber(marks()) - 1, 0)
    local startcol = math.max(tonumber(marks()) - 1, 0)
    local endline = math.max(tonumber(marks()) -1, 0)
    local endcol = tonumber(marks())
    local numstmt = tonumber(marks())
    local cnt = tonumber(marks())

    local hig = "GocUncovered"
    if cnt == 1 then
      hig = "GocCovered"
    end

    for y = startline,endline do
      local sc = 0
      local ec = -1
      if startline == y then
        sc = startcol
      end
      if endline == y then
        ec = endcol
      end

      vim.api.nvim_buf_add_highlight(bufnr, M.hi, hig, y, sc, ec)
    end

  end

  -- set content
  vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, content)
end

return M
