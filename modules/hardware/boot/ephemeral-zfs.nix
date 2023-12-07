{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.hardware.boot.ephemeral-zfs;
  phase1Systemd = config.boot.initrd.systemd.enable;
  wipeScript = ''
    zfs rollback -r rpool/local/root@blank && echo "rollback complete"
  '';
in {
  options.modules.hardware.boot.ephemeral-zfs = {
    enable = mkBoolOpt false;
    hostId = mkOpt types.str "1d396c91";
  };

  config = mkIf cfg.enable {

    networking.hostId = "${config.modules.hardware.boot.ephemeral-zfs.hostId}";
		
    boot.initrd = {
      postDeviceCommands = lib.mkIf (!phase1Systemd) (lib.mkAfter wipeScript);
      systemd.services.rollback = lib.mkIf phase1Systemd {
        description = "Rollback ZFS datasets to a prisitine state";
        wantedBy = [ "initrd.target" ];
        after =
          [ "systemd-cryptsetup@crypt.service" "zfs-import-rpool.service" ];
        before = [ "sysroot.mount" ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.type = "oneshot";
        script = wipeScript;
      };
    };

    security.sudo.extraConfig = ''
      # rollback results in sudo lectures after each reboot
      Defaults lecture = never
    '';

  };
}
