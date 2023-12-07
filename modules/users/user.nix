{ inputs, config, options, lib, pkgs, ... }:

with builtins;
with lib;
with lib.my;
let
  cfg = config.modules.users.user;
  ifTheyExist = groups:
    builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  options.modules.users.user = {
    enable = mkBoolOpt false;
    username = mkOpt types.str "seth";
    password = mkOpt types.str "nixos";
  };

  config = mkIf cfg.enable {

    user = let
      user = "${config.modules.users.user.username}";
      name = user;
    in {
      inherit name;
      isNormalUser = true;
      shell = pkgs.zsh;
      home = "/home/${name}";
      group = "users";
      uid = 1000;
      extraGroups = [ "wheel" "video" "audio" ]
        ++ ifTheyExist [ "network" "NetworkManager" "wireshark" "i2c" "git" ];
      initialPassword = "nixos";
      #hashedPasswordFile = config.sops.secrets.misterio-password.path;
    };

    users.users.${config.user.name} = mkAliasDefinitions options.user;
  };
}
