-- Test bootstrap: run with `tests/run.sh`.
local root = assert(os.getenv("NVIM_FOUNTAIN_ROOT"), "NVIM_FOUNTAIN_ROOT must be set")

vim.opt.rtp:prepend(root)
-- Plugin managers add the plugin's after/ directory to 'runtimepath' as well.
vim.opt.rtp:append(root .. "/after")
package.path = root .. "/?.lua;" .. package.path

vim.cmd("filetype plugin on")
vim.cmd("syntax enable")

local harness = require("tests.harness")
harness.load(root)
harness.finish()
