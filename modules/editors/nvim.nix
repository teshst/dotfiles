{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.nvim;
    configDir = config.dotfiles.configDir;
in {
  options.modules.editors.nvim = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home-manager.users."${config.user.name}".programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        dashboard-nvim
        which-key-nvim
        onedark-nvim
        nerdtree
        indent-blankline-nvim
        orgmode
        markdown-preview-nvim
     ];
    };

    home.configFile = {
      "nvim" = {
        source = "${configDir}/nvim";
        recursive = true;
      };
    };
  };
}
