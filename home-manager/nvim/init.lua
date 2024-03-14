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
  })
end
vim.opt.rtp:prepend(lazypath)

-- Install plugins
require("lazy").setup({

    -- File explorer
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

require("bufferline").setup{} -- Open bufferline on startup

vim.g.mapleader = " " -- Set leader to space

-- Options
vim.opt.wrap = false

-- Mappings
vim.keymap.set('n', "<Leader>e", ":Neotree toggle<cr>")

-- I think only one of these should be enabled at a time
vim.cmd[[colorscheme lushwal]]
--vim.opt.termguicolors = true
