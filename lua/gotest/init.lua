local execute  = require("gotest.execute")
local generate = require("gotest.generate")
local coverage = require("gotest.coverage")

local M = {}

M.setup = function()
end

M.run_test = execute.run_test
M.show_last_test_result = execute.show_last_test_result
M.run_last_test = execute.run_last_test
M.clean_last_run = execute.clean_last_run

M.generate_function_test = generate.genereate_function_test

M.show_coverage = coverage.show_coverage

return M
