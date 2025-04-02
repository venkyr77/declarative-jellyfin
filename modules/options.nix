{lib, ...}:
with lib; {
  options.services.declarative-jellyfin = {
    enable = mkEnableOption "Jellyfin Service";

    # TODO: implement options
  };
}
