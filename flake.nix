{
  description = "My custom nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware";

    impermanence.url = "github:nix-community/impermanence";

    flake-utils.url = "github:numtide/flake-utils";

    emacs-overlay.url = "github:nix-community/emacs-overlay";

    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # extra
    nur.url = "github:nix-community/NUR";
  };

  outputs =
    { self
    , nixpkgs
    , ...
    } @ inputs:
    let
      inherit (lib.my) mapModules mapModulesRec mapHosts;

      system = "x86_64-linux";

      mkPkgs = pkgs: extraOverlays: import pkgs {
        inherit system;
        config.allowUnfree = true; # forgive me Stallman senpai
        overlays = extraOverlays ++ (lib.attrValues self.overlays);
      };
      pkgs = mkPkgs nixpkgs [ self.overlays.default ];

      lib = nixpkgs.lib.extend
        (self: super: { my = import ./lib { inherit pkgs inputs; lib = self; }; });
    in
    {
      lib = lib.my;

      # Custome packages as overlats
      overlays.default =
        final: prev: {
          my = self.packages."${system}";
        };

      overlays.custom =
        final: prev:
          (mapModules ./overlays import);

      packages."${system}" =
        mapModules ./packages (p: pkgs.callPackage p {});

      devShells."${system}".default =
        import ./shell.nix { inherit pkgs; };

      nixosModules =  
        { dotfiles = import ./.; } // mapModulesRec ./modules import;

      # NixOS configuration entrypoint
      nixosConfigurations =
        mapHosts ./hosts { };

      templates = {
        full = {
          path = ./.;
          description = "A grossly incandescent nixos config";
        };
      } // import ./templates;
      defaultTemplate = self.templates.full;
    };
}
