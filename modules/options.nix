{ inputs, config, options, lib, home-manager, ... }:

with lib;
with lib.my;
{
  options = with types; {
    user = mkOpt attrs { };

    dotfiles = {
      dir = mkOpt path
        (removePrefix "/mnt"
          (findFirst pathExists (toString ../.) [
            "/mnt/etc/dotfiles"
            "/home/${config.user.name}/dotfiles"
          ]));
      binDir = mkOpt path "${config.dotfiles.dir}/bin";
      configDir = mkOpt path "${config.dotfiles.dir}/config";
      modulesDir = mkOpt path "${config.dotfiles.dir}/modules";
    };

    home = {
      configFile = mkOpt' attrs { } "Files to place in $XDG_CONFIG_HOME";
      dataFile = mkOpt' attrs { } "Files to place in $XDG_DATA_HOME";
      programs = mkOpt' attrs { } "Access to home-manager programs";
      services = mkOpt' attrs { } "Access to home-manager services";
      persistence = mkOpt' attrs { } "Access to home-manager persistence";
      file = mkOpt' attrs { } "Files to place directly in $HOME";
    };

    env = mkOption {
      type = attrsOf (oneOf [ str path (listOf (either str path)) ]);
      apply = mapAttrs
        (n: v:
          if isList v
          then concatMapStringsSep ":" (x: toString x) v
          else (toString v));
      default = { };
      description = "TODO";
    };
  };

  config = {
    user =
      let
        user = builtins.getEnv "USER";
        name = if elem user [ "" ] then "seth" else user;
      in
      {
        inherit name;
        extraGroups = [ "wheel" ];
        isNormalUser = true;
        home = "/home/${name}";
        group = "users";
        uid = 1000;
        initialPassword = "nixos";
      };

    # Install user packages to /etc/profiles instead. Necessary for
    # nixos-rebuild build-vm to work.
    home-manager = {
      useUserPackages = true;
      #useGlobalPkgs = true;

      users.${config.user.name} = {
        programs = mkAliasDefinitions options.home.programs;
        services = mkAliasDefinitions options.home.services;

        imports = with inputs; [
          impermanence.nixosModules.home-manager.impermanence
        ];

        home = {
          # Aliases
          file = mkAliasDefinitions options.home.file;
          persistence = mkAliasDefinitions options.home.persistence;

          username = "${config.user.name}";
          homeDirectory = "${config.user.home}";


          stateVersion = config.system.stateVersion;
        };
        xdg = {
          configFile = mkAliasDefinitions options.home.configFile;
          dataFile = mkAliasDefinitions options.home.dataFile;
        };
      };
    };

    users.users.${config.user.name} = mkAliasDefinitions options.user;

    nix.settings = let users = [ config.user.name ]; in {
      trusted-users = users;
      allowed-users = users;
    };

    env.PATH = [ "$DOTFILES_BIN" "$XDG_BIN_HOME" "$PATH" ];

    environment.extraInit =
      concatStringsSep "\n"
        (mapAttrsToList (n: v: "export ${n}=\"${v}\"") config.env);
  };
}
