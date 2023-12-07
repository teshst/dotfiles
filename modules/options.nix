{ inputs, config, options, lib, home-manager, ... }:

with lib;
with lib.my; {
  options = with types; {
    user = mkOpt attrs { };

    dotfiles = {
      dir = mkOpt path (removePrefix "/mnt"
        (findFirst pathExists (toString ../.) [
          "/mnt/etc/dotfiles"
          "/etc/dotfiles"
        ]));
      binDir = mkOpt path "${config.dotfiles.dir}/bin";
      configDir = mkOpt path "${config.dotfiles.dir}/config";
      modulesDir = mkOpt path "${config.dotfiles.dir}/modules";
    };

    home = {
      file = mkOpt' attrs { } "Files to place directly in $HOME";
      configFile = mkOpt' attrs { } "Files to place in $XDG_CONFIG_HOME";
      dataFile = mkOpt' attrs { } "Files to place in $XDG_DATA_HOME";

      # home manager quick access
      programs = mkOpt' attrs { } "Access to home-manager programs";
      services = mkOpt' attrs { } "Access to home-manager services";
    };

    env = mkOption {
      type = attrsOf (oneOf [ str path (listOf (either str path)) ]);
      apply = mapAttrs (n: v:
        if isList v then
          concatMapStringsSep ":" (x: toString x) v
        else
          (toString v));
      default = { };
      description = "TODO";
    };
  };

  config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      users.${config.user.name} = {
        programs = mkAliasDefinitions options.home.programs;
        services = mkAliasDefinitions options.home.services;

        home = {
          # Aliases
          file = mkAliasDefinitions options.home.file;

          stateVersion = config.system.stateVersion;
        };
        xdg = {
          configFile = mkAliasDefinitions options.home.configFile;
          dataFile = mkAliasDefinitions options.home.dataFile;
        };
      };
    };

    home.programs.home-manager.enable = true;

    nix.settings = let users = [ config.user.name ];
    in {
      trusted-users = users;
      allowed-users = users;
    };

    env.PATH = [ "$DOTFILES_BIN" "$XDG_BIN_HOME" "$PATH" ];

    environment.extraInit = concatStringsSep "\n"
      (mapAttrsToList (n: v: ''export ${n}="${v}"'') config.env);
  };
}
