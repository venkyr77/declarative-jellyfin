{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.declarative-jellyfin;
in {
  config = mkIf cfg.enable {
    # TODO: implement
  };
}
