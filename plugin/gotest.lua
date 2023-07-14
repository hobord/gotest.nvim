-- An Gotest
-- URL: https://github.com/hobord/gotest.nvim

-- check plugin Neovim requirements
if vim.fn.has 'nvim-0.8' ~= 1 then
  vim.opt_local.statusline = 'gotest requires Neovim 0.8, or later'
  return
end

-- load plugin only once
if vim.g.hobord_gotest_loaded ~= nil then return end

-- set neovim plugin variables
vim.g.hobord_gotest_loaded = true

vim.api.nvim_create_user_command('GenerateGoTest', function() require('gotest.generate_test').generate_function_test() end , {})
