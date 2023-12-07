{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.boot.encrypted-root;
in {
  options.modules.hardware.boot.encrypted-root = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    boot.initrd.luks.devices."crypt" =
      {
        device = "/dev/disk/by-label/crypt";
        preLVM = true;
      };
  };
}
