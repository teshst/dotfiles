{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.editors.emacs;
  configDir = config.dotfiles.configDir;
in {
  options.modules.editors.emacs = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];

    environment.systemPackages = with pkgs; [

      ((emacsPackagesFor emacs-unstable).emacsWithPackages
        (epkgs: [ epkgs.vterm ])) # required dependencies
      git
      ripgrep

      # optional dependencies
      coreutils # basic GNU utilities
      fd
      clang
      imagemagick # for image-dired
      (mkIf (config.programs.gnupg.agent.enable)
        pinentry-emacs) # in-emacs gnupg prompts
      zstd # for undo-fu-session/undo-tree compression

      ## Module dependencies
      # :checkers spell
      (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
      # :tools editorconfig
      editorconfig-core-c # per-project style config
      # :tools lookup & :lang org +roam
      sqlite
      # :lang latex & :lang org (latex previews)
      texlive.combined.scheme-medium
      # :nix
      nixfmt
      nil
    ];

    env.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];

    fonts.packages = [ pkgs.emacs-all-the-icons-fonts ];

    services.emacs.enable = true;

    system.userActivationScripts = {
      # Installation Script on Rebuild
      installDoomEmacs = {
        text = ''
          if [ ! -d "$XDG_CONFIG_HOME/emacs/bin" ]; then
            ${pkgs.git}/bin/git clone https://github.com/hlissner/doom-emacs.git "$XDG_CONFIG_HOME/emacs"
            ${pkgs.git}/bin/git clone https://github.com/teshst/.doom.d.git "$XDG_CONFIG_HOME/doom"
          fi
        '';
      };
    };

    environment.persistence."/persist" = {
      hideMounts = true;
      users.${config.user.name} = {
        directories = [
          {
            directory = ".config/emacs";
            mode = "0700";
          }
          {
            directory = ".config/doom";
            mode = "0700";
          }
        ];
      };
    };
  };
}
