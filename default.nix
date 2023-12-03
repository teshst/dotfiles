{ inputs, config, lib, pkgs, ... }:

with lib;
with lib.my;
{
  imports = with inputs;
    [
      home-manager.nixosModules.home-manager
      impermanence.nixosModules.impermanence
      nur.nixosModules.nur
    ]
    # All my personal modules
    ++ (mapModulesRec' (toString ./modules) import);

  environment.variables.DOTFILES = config.dotfiles.dir;
  environment.variables.DOTFILES_BIN = config.dotfiles.binDir;

  networking.hostId = lib.mkDefault "1d396c91";
  xdg.portal.enable = true;

  boot.supportedFilesystems = [ "zfs" ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    systemd-boot.enable = true;
  };

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/root@blank
  '';

  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';

  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
  nix =
    let
      filteredInputs = filterAttrs (n: _: n != "self") inputs;
      nixPathInputs = mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
      registryInputs = mapAttrs (_: v: { flake = v; }) filteredInputs;
    in
    {
      package = pkgs.nixFlakes;
      extraOptions = "experimental-features = nix-command flakes";
      nixPath = nixPathInputs ++ [
        "nixpkgs-overlays=${config.dotfiles.dir}/overlays"
        "dotfiles=${config.dotfiles.dir}"
      ];
      registry = registryInputs // { dotfiles.flake = inputs.self; };
      settings = {
        auto-optimise-store = true;
      };
    };

  system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;
  system.stateVersion = "23.05";

  ## Some reasonable, global defaults
  # This is here to appease 'nix flake check' for generic hosts with no
  # hardware-configuration.nix or fileSystem config.
  fileSystems."/".device = mkDefault "/dev/disk/by-label/crypt";

  environment.systemPackages = with pkgs; [
    cached-nix-shell
    git
    neovim
    wget
    gnumake
    unzip
    nixpkgs-fmt
    cmake
  ];

}
