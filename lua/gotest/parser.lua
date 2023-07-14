local M = {}

local ts_utils = require'nvim-treesitter.ts_utils'
local Path = require("plenary.path")
local lastrun  = require("gotest.lastrun")

M.get_function_name = function ()
  local current_node = ts_utils.get_node_at_cursor()
  if not current_node then return "" end

  local expr = current_node

  while expr do
      if expr:type() == 'function_declaration' then
          break
      end
      expr = expr:parent()
  end

  if not expr then return "" end

  return (ts_utils.get_node_text(expr:child(1)))[1]
end

M.get_module_name = function()
  local mod_name_re = "^module (.*)$"
  local cwd = vim.fn.expand('%:p:h')
  local p = Path:new(cwd):find_upwards("go.mod")

  if p == "" then
      return ""
  end
  
  local lines = p:readlines()
  
  for _, line in ipairs(lines) do
      if line:match(mod_name_re) then
          local name = line:match(mod_name_re)
  
          
          return name
      end
  end
  
  return ""
end

M.get_module_path = function()
  local mod_name_re = "^module (.*)$"
  local cwd = vim.fn.expand('%:p:h')
  local p = Path:new(cwd):find_upwards("go.mod")

  if p == "" then
      return ""
  end
  
  
  return p:parent():absolute()
end



return M
