{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.components.fonts;
in {
  options.modules.desktop.components.fonts = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      packages = with pkgs; [
        ubuntu_font_family
        dejavu_fonts
        symbola
      ];
    };
  };
}
