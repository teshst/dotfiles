{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.boot.systemd-boot;
in {
  options.modules.hardware.boot.systemd-boot = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    boot.loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot.enable = true;
    };
  };
}
