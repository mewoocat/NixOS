{ config, pkgs, lib, inputs, ... }: 

{
  programs.neovim = 
  let
    toLua = str: "lua << EOF\n${str}\nEOF\n"; # Run lua string as vimscript
    toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n"; # Run lua file as vimscript
  in
  {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    coc.enable = true;
    plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-treesitter.withAllGrammars;
        config = ""; 
      }
      {
        plugin = telescope-nvim;
        config = toLuaFile ./telescope.lua;
      }
      {
        plugin = bufferline-nvim;
        config = toLua "require(\"bufferline\").setup()";
      }
      {
        plugin = neo-tree-nvim;
        config = "";
      }
      {
        plugin = pywal-nvim;
        config = "";
      } 
      {
        plugin = indent-blankline-nvim;
        config = toLua "require(\"ibl\").setup()";
      }
    ];
    extraLuaConfig = ''
        ${builtins.readFile ./init.lua}
    '';
  };
}
