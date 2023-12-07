{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.zsh;
  configDir = config.dotfiles.configDir;
in {
  options.modules.shell.zsh = with types; { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    users.defaultUserShell = pkgs.zsh;

    programs.zsh.enable = true;

    env = {
      ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
      ZSH_CACHE = "$XDG_CACHE_HOME/zsh";
      ZGEN_DIR = "$XDG_DATA_HOME/zgenom";
    };

    home.programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableVteIntegration = true;
      syntaxHighlighting.enable = true;
      history = {
        path = ".local/share/zsh/zsh_history";
        save = 10000;
        share = true;
        ignoreAllDups = true;
        ignoreSpace = true;
      };
      dotDir = ".config/zsh";
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = "${configDir}/zsh/p10k-config";
          file = "p10k.zsh";
        }
      ];
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" ];
      };
    };

    fonts.packages = [ pkgs.meslo-lgs-nf ];

    #home.persistence."/persist/home/${config.user.name}" = {
    #  directories = [ ".config/zsh" ];
    #  files = [ ".local/share/zsh/zsh_history" ];
    #};

    environment.persistence."/persist" = {
      hideMounts = true;
      users.${config.user.name} = { files = [ ".local/share/zsh/zsh_history" ]; };

    };
  };
}
