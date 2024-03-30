-- Setup pywal
--local pywal = require('pywal')
--pywal.setup()
vim.cmd.colorscheme = "pywal"

-- Setup neogit
local neogit = require('neogit')
neogit.setup {}

vim.g.mapleader = " " -- Set leader to space

-- Options
--------------------------------------------------------------
vim.opt.wrap = true
vim.opt.clipboard = "unnamedplus" -- External clipboard support
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = ""
--vim.opt.termguicolors = true
--vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- Disables kitty padding on entry and enables on exit
-- Only needed when settings a specific theme since the padding in kitty will not match the bg color
--[[
vim.cmd [[
augroup kitty_mp
  autocmd!
  au VimLeave * if !empty($KITTY_WINDOW_ID) | :silent !kitty @ set-spacing padding=default margin=default
  au VimEnter * if !empty($KITTY_WINDOW_ID) | :silent !kitty @ set-spacing padding=0 margin=0
augroup END
]]
--]]

-- Tab config
vim.opt.tabstop = 4 -- A TAB character looks like 2 spaces
vim.opt.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.opt.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.opt.shiftwidth = 4 -- Number of spaces inserted when indenting

-- Mappings
--------------------------------------------------------------
vim.keymap.set('n', "<Leader>e", ":Neotree toggle<cr>")
vim.keymap.set('n', '<leader>n', ":bnext<cr>", {})
vim.keymap.set('n', '<leader>b', ":bprev<cr>", {})
vim.keymap.set({ "n", "v", "o", "c", "i" }, "<MiddleMouse>", "<Nop>") -- Disable middle mouse paste
vim.keymap.set('n', '<leader>g', ":Neogit<cr>", {})
vim.keymap.set('n', '<leader>w', ":bd<cr>")
