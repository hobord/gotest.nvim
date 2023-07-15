# Gotest

## features

-  Run go test ./... in the current opened file package directory
-  Show latest results of the test
-  Run got test with specific test function according to the current cursor
   position
-  Run the latest test again ignoring to the current position the cursor/file
-  Generate untit test for the current function using gotests cmd

## install, dependencies

install gotests
```
    go get -u github.com/cweill/gotests/...
```

load module
```
    use {
      'hobord/gotest.nvim',
      requires = { 
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        'nvim-lua/popup.nvim',
      },
    }
```

## commands

 `GenerateGoTest` generates unit test for the curent function

 ```
 map("n", "<Leader>rt",  function() require('gotest').run_test() end, { noremap = true, silent = true, nowait = true, desc="Run test" })
 map("n", "<Leader>r[",  function() require('gotest').clean_last_run() end, { noremap = true, silent = true, nowait = true, desc="CleanLastRun" })
 map("n", "<Leader>re",  function() require('gotest').show_last_test_result() end, { noremap = true, silent = true, nowait = true, desc="Show test result" })
```
