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
        "/var/lib/systemd"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/etc/NetworkManager/system-connections"
      ];
      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
      ];
    };
    programs.fuse.userAllowOther = true;

    # Home Persistence
    home.persistence."/persist/home/${config.user.name}" = {
      directories = [
        "Documents"
        "Downloads"
        "Pictures"
        "Videos"
        "Music"
        ".ssh"
        ".gnupg"
        "nix-config"
				"dotfiles"
        ".local/share/keyrings"
        ".local/share/direnv"
				".local/share/fonts"
      ];
      files = [
        ".local/share/bash/history"
      ];
      allowOther = true;
    };
  };
}
