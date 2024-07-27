
-- Globals
--------------------------------------------------------------
vim.g.mapleader = " " -- Set leader to space


-- Setup pywal
--------------------------------------------------------------
--local pywal = require('pywal')
--pywal.setup()
vim.cmd.colorscheme = "wal" -- use wal or fork it.  pywal-nvim is borked for reload
--vim.cmd("colorscheme pywal") -- Appears to require theme reload for syntax colors
---- DO I even need pywal for syncing terminal (pywal) colors with nvim???

-- Setup neogit
--------------------------------------------------------------
local neogit = require('neogit')
neogit.setup {}

-- Setup coc
--------------------------------------------------------------
local keyset = vim.keymap.set
-- Autocomplete
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use Tab for trigger completion with characters ahead and navigate
-- NOTE: There's always a completion item selected by default, you may want to enable
-- no select by setting `"suggest.noselect": true` in your configuration file
-- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
-- other plugins before putting this into your config
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice
keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- Setup telescope
--------------------------------------------------------------
local builtin = require('telescope.builtin') -- Import telescope functions
vim.keymap.set('n', '<leader>o', builtin.find_files, {})
vim.keymap.set('n', '<leader>f', builtin.live_grep, {})




-- Options
--------------------------------------------------------------
vim.opt.wrap = false
vim.opt.clipboard = "unnamedplus" -- External clipboard support
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = ""

--vim.opt.termguicolors = true

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

--vim.cmd("nnoremap <silent> <esc><esc> :nohlsearch<CR><esc>")

-- Testing
--------------------------------------------------------------
--vim.cmd("autocmd BufWritePost ~/.cache/wal/colors-wal.vim :source ~/.config/nvim/init.lua")
--vim.api.nvim_create_autocmd({"BufWritePost"}, {
--    pattern = {"/home/eXia/.cache/wal/colors-wal.vim"},
--    --command = ":source /home/eXia/.config/nvim/init.lua",
--    command = "colorscheme pywal",
--})

-- Define a function to set the colorscheme to pywal
--local function set_pywal_colorscheme()
--    vim.cmd('colorscheme pywal')
--end

--vim.cmd [[
--augroup AutoPywal
--  autocmd!
--  au BufWritePost ~/.cache/wal/colors-wal.vim colorscheme pywal
--augroup END
--]]


-- Testing this at the end since it seems that after launching nvim, i have to
-- set the colorscheme to wal for all elements to take effect
vim.cmd.colorscheme = "wal"
