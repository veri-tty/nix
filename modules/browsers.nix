{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  options = {
    floorp = {
      enable = lib.mkEnableOption {
        description = "Enable Floorp";
        default = false;
      };
    };
  };
  config = lib.mkIf config.floorp.enable {
    home-manager.users.ml.programs.floorp = {
      enable = true;
      profiles = {
        tech = {
          id = 0;
          name = "tech";
          isDefault = true;
          path = "tech.default";
          extensions.packages = with inputs.rycee.packages.x86_64-linux; [
            bitwarden
            ublock-origin
            privacy-badger
            linkwarden
          ];
        };
        velor = {
          id = 1;
          name = "velor";
          isDefault = false;
          path = "velor.default";
          extensions.packages = with inputs.rycee.packages.x86_64-linux; [
            bitwarden
            ublock-origin
            privacy-badger
            linkwarden
          ];
        };
      };
    };
  };
}
