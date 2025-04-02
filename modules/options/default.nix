{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.declarative-jellyfin;
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

    config =
      mkIf cfg.enable
      (
        let
          toXml = name: x: (toXMLGeneric {
            inherit name;
            properties = {
              "xmlns:xsi" = "http://www.w3.org/2001/XMLSchema-instance";
              "xmlns:xsd" = "http://www.w3.org/2001/XMLSchema";
            };
            content = x;
          });
        in {
          system.activationScripts."link-network-xml" =
            lib.stringAfter ["var"] (toXml "NetworkConfiguration" cfg.network);
        }
      );
  }
