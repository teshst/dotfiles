{ inputs, ... }:

{

  imports = [ 
   inputs.hardware.nixosModules.omen-16-n0005ne

   ../home.nix 
   ./hardware-configuration.nix 
 ];

  modules = {
    users = { user.enable = true; };
    hardware = {
      audio.enable = true;
      bluetooth.enable = true;
      fs = {
        enable = true;
	ssd.enable = true; 
      };
      optin-persistence.enable = true;
    };
    desktop = {
      gnome.enable = true;
      browsers = { firefox.enable = true; };
      components = { fonts.enable = true; };
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
    services = { ssh.enable = true; };
  };

  ## Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  networking.networkmanager.enable = true;

  time.timeZone = "America/Boise";

}
