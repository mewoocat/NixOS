{ config, pkgs, lib, inputs, ... }: 

{
  
  # Store lua files out of store so that they can be edited without rebuild
  home.file = {
   ".config/nvim/lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/NixOS/home-manager/programs/nvim/lua";
  };

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
        #config = toLuaFile ./telescope.lua;
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
        plugin = wal-vim;
        config = "";
      } 
      {
        plugin = indent-blankline-nvim;
        config = toLua "require(\"ibl\").setup()";
      }
      {
        plugin = neogit;
        config = "";
      }
    ];
    # Import out of store lua files
    # Lua files HAVE to be in a lua/ dir and HAVE to be imported with just the name not the extension
    extraLuaConfig = ''
	    require('setup')
    '';
  };
}
