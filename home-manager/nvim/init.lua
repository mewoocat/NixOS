-- Note: Some plugins may need to be installed via HomeManager to work correctly in NixOS

-- Install the Lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
-- Mappings
--------------------------------------------------------------
  })
end
vim.opt.rtp:prepend(lazypath)

-- Install plugins
--------------------------------------------------------------
require("lazy").setup({

    -- File finder
    {
      'nvim-telescope/telescope.nvim', tag = '0.1.6',
        dependencies = { 
          'nvim-lua/plenary.nvim',
          'nvim-treesitter/nvim-treesitter',
        }
    },

    -- File explorer
    -- TODO Switch to nvim-tree-lua for better pywal support
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        }
    },

    -- Tabline
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        }
    },


    -- pywal
    {
        "oncomouse/lushwal.nvim",
        cmd = { "LushwalCompile" },
        dependencies = {
            { "rktjmp/lush.nvim" },
            { "rktjmp/shipwright.nvim" },
        },
    },

})

require("bufferline").setup() -- Open bufferline on startup
local builtin = require('telescope.builtin') -- Import telescope functions


vim.g.mapleader = " " -- Set leader to space

-- Options
--------------------------------------------------------------
vim.opt.wrap = true
vim.opt.clipboard = "unnamedplus" -- External clipboard support
vim.opt.number = true
vim.opt.relativenumber = true

-- Tab config
vim.opt.tabstop = 2 -- A TAB character looks like 2 spaces
vim.opt.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.opt.softtabstop = 2 -- Number of spaces inserted instead of a TAB character
vim.opt.shiftwidth = 2 -- Number of spaces inserted when indenting

-- Mappings
--------------------------------------------------------------
vim.keymap.set('n', "<Leader>e", ":Neotree toggle<cr>")
vim.keymap.set('n', '<leader>o', builtin.find_files, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set('n', '<leader>n', ":bnext<cr>", {})
vim.keymap.set('n', '<leader>b', ":bprev<cr>", {})

-- Theme
--------------------------------------------------------------
-- I think only one of these should be enabled at a time
vim.cmd.colorscheme = "lushwal"
--vim.opt.termguicolors = true
