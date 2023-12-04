{ inputs, ... }:

{

  imports = [
    ../home.nix
    ./hardware-configuration.nix

    #inputs.hardware.nixosModules.omen-16-n0005ne
  ];

  modules = {
    hardware = {
      audio.enable = true;
      bluetooth.enable = true;
      fs.enable = true;
      optin-persistence.enable = true;
    };
    desktop = {
      gnome.enable = true;
      browsers = {
        firefox.enable = true;
      };
    };
    editors = {
      default = "nvim";
      nvim.enable = true;
      emacs.enable = true;
    };
    shell = {
      zsh.enable = true;
      git.enable = true;
      gnupg.enable = true;
    };
    services = {
      ssh.enable = true;
    };
  };

  ## Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  networking.networkmanager.enable = true;
  networking.hostId = "1d396c91";

  time.timeZone = "America/Boise";

}
