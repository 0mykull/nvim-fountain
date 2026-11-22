-- Fountain filetype plugin
local keymaps = require('nvim-fountain.keymaps')

-- Set up buffer-local options
vim.bo.commentstring = "/* %s */"

-- Set up keymaps
keymaps.setup(require('nvim-fountain').config)
