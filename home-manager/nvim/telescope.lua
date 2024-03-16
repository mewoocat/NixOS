
--TODO: Figure out how to import this from the rest of the lua config
vim.g.mapleader = " " -- Set leader to space

local builtin = require('telescope.builtin') -- Import telescope functions
vim.keymap.set('n', '<leader>o', builtin.find_files, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
