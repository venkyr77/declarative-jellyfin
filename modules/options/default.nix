{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.declarative-jellyfin;
  toXml' = (import ../../lib {nixpkgs = pkgs;}).toXMLGeneric;
in
  with lib; {
    imports = [
      ./system.nix
      ./encoding.nix
      ./network.nix
      ./branding.nix
    ];
    options.services.declarative-jellyfin = {
      enable = mkEnableOption "Jellyfin Service";
    };
  }
