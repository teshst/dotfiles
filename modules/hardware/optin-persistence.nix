{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.optin-persistence;
in {
  options.modules.hardware.optin-persistence = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # System-Wide Persistence
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/var/log"
	"/var/lib/bluetooth"
      	"/var/lib/nixos"
      	"/var/lib/systemd/coredump"
        "/etc/NetworkManager/system-connections"
      	{ directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
      ];
      files = [
        "/etc/machine-id"
        "/var/lib/NetworkManager/secret_key"
        "/var/lib/NetworkManager/seen-bssids"
        "/var/lib/NetworkManager/timestamps"
	{ file = "/etc/nix/id_rsa"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
      ];
      users.${config.user.name} = {
        directories = [
          "Downloads"
          "Music"
          "Pictures"
          "Documents"
          "Videos"
          { directory = ".gnupg"; mode = "0700"; }
          { directory = ".ssh"; mode = "0700"; }
          { directory = "dotfiles"; mode = "0700"; }
        ];
        files = [ ".screenrc" ".local/share/bash/history" ];
      };
    };
    programs.fuse.userAllowOther = true;

    # Home Persistence
    # home.persistence."/persist/home/${config.user.name}" = {
    #   directories = [
    #     "Documents"
    #     "Downloads"
    #     "Pictures"
    #     "Videos"
    #     "Music"
    #     ".ssh"
    #     ".gnupg"
    #     "dotfiles"
    #     ".local/share/fonts"
    #     ".local/bin"
    #   ];
    #   files = [ ".local/share/bash/history" ];
    #   allowOther = true;
    #};
  };
}
