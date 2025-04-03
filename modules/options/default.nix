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

    config =
      mkIf cfg.enable
      (
        let
          isStrList = x: builtins.all (x: builtins.isString x) x;
          prepass = x:
            if (builtins.isAttrs x)
            then
              if !(builtins.hasAttr "tag" x)
              then
                attrsets.mapAttrsToList
                (tag: value: {
                  inherit tag;
                  content = prepass value;
                })
                x
              else if (builtins.hasAttr "content" x)
              then {
                tag = x.tag;
                content = prepass x.content;
              }
              else x
            else if (builtins.isList x)
            then
              if (isStrList x)
              then
                (builtins.map (content: {
                  tag = "string";
                  inherit content;
                })
                x)
              else builtins.map prepass x
            else x;

          toXml = tag: x: (toXml' {
            inherit tag;
            attrib = {
              "xmlns:xsi" = "http://www.w3.org/2001/XMLSchema-instance";
              "xmlns:xsd" = "http://www.w3.org/2001/XMLSchema";
            };
            content = prepass x;
          });
        in {
          system.activationScripts."link-network-xml" =
            lib.stringAfter ["var"]
            (
              let
                storeFile = pkgs.writeText "network.xml" (toXml "NetworkConfiguration" cfg.network);
              in ''
                echo "[Declarative Jellyfin] Creating /var/lib/jellyfin/config"
                mkdir -p "/var/lib/jellyfin/config"
                echo "[Declarative Jellyfin] Linking ${storeFile} to /var/lib/jellyfin/config/network.xml"
                cp -s "${storeFile}" "/var/lib/jellyfin/config/network.xml"
              ''
            );
        }
      );
  }
