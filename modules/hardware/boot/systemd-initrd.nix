{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.boot.systemd-initrd;
in {
  options.modules.hardware.boot.systemd-initrd = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    boot.initrd.systemd.enable = true;
  };
}
