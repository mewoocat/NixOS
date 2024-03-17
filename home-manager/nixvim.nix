# A set that contains the nixvim config
{
    #colorschemes.gruvbox.enable = true;

    extraConfigLuaPre = ''

        vim.g.mapleader = " " -- Set leader to space

        -- Options
        --------------------------------------------------------------
        vim.opt.wrap = true
        vim.opt.clipboard = "unnamedplus" -- External clipboard support
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.mouse = ""

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
    '';

    plugins = {
        telescope.enable = true;
        treesitter.enable = true;
        bufferline.enable = true;
        neo-tree.enable = true;
    };
}