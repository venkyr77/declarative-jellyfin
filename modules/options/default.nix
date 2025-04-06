{lib, ...}:
with lib; {
  imports = [
    ./system.nix
    ./encoding.nix
    ./network.nix
    ./branding.nix
    ./users.nix
  ];
  options.services.declarative-jellyfin = {
    enable = mkEnableOption "Jellyfin Service";
  };
}
