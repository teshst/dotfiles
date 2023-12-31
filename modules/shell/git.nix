{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.git;
in {
  options.modules.shell.git = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      gitAndTools.git-annex
      gitAndTools.git-open
      gitAndTools.diff-so-fancy
      (mkIf config.modules.shell.gnupg.enable
        gitAndTools.git-crypt)
      act
    ];
    

    home.programs.git = {
     enable = true;
     userName = "teshst";
     userEmail = "teshpersonal@gmail.com";
    };
   };
}
