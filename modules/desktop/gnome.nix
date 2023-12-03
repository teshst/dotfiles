{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.gnome;
in {
  options.modules.desktop.gnome = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
		
		services.gnome.gnome-keyring.enable = true;
		security.pam.services.gdm.enableGnomeKeyring = true;

    environment = {
      systemPackages = with pkgs; [

      ] ++ (with pkgs.gnomeExtensions; [
        appindicator
        caffeine
        blur-my-shell
        just-perfection
        clipboard-indicator
      ]);

      gnome.excludePackages = with pkgs; [
        gnome-tour
      ] ++ (with pkgs.gnome; [
        cheese # webcam tool
        gnome-terminal
        epiphany # web browser
        geary # email reader
        gnome-characters
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
      ]);
    };

    programs.dconf = {
      enable = true;
      profiles = {
        user.databases = [{
          settings = with lib.gvariant; {
            "org/gnome/desktop/interface".color-scheme = "prefer-dark";

            "org/gnome/shell".enabled-extensions = [
              "blur-my-shell@aunetx"
              "clipboard-indicator@tudmotu.com"
              "just-perfection-desktop@just-perfection"
              "caffeine@patapon.info"
              "appindicatorsupport@rgcjonas.gmail.com"
            ];
          };
        }];
      };
    };
  };
}
