{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.declarative-jellyfin;
in {
  options.services.declarative-jellyfin = {
    enable = mkEnableOption "Jellyfin Service";

    # TODO: implement options
  };

  config = mkIf cfg.enable {
    # TODO: implement
  };
}
