# Shell for bootstrapping flake-enabled nix and other tooling
{ pkgs ? import <nixpkgs> {} }:# If pkgs is not defined, instanciate nixpkgs from locked commit
  
  pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";
    nativeBuildInputs = with pkgs; [
      nix
      home-manager
      git

      sops
      ssh-to-age
      gnupg
      age
    ];
  }
