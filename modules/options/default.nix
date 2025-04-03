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
          prepass = x:
            if (builtins.isAttrs x)
            then
              if !(builtins.hasAttr "tag" x)
              then
                attrsets.mapAttrsToList (tag: value: {
                  inherit tag;
                  content = value;
                })
                x
              else if (builtins.hasAttr "content" x)
              then {
                tag = x.tag;
                content = prepass x.content;
              }
              else x
            else if (builtins.isList x)
            then builtins.map prepass x
            else throw "wtf";

          toXml = tag: x: (toXml' {
            inherit tag;
            attrib = {
              "xmlns:xsi" = "http://www.w3.org/2001/XMLSchema-instance";
              "xmlns:xsd" = "http://www.w3.org/2001/XMLSchema";
            };
            content = x;
          });
        in {
          system.activationScripts."link-network-xml" = lib.stringAfter ["var"] (
            let
              content = toXml "NetworkConfiguration" (prepass cfg.network);
            in ''
              mkdir -p /var/lib/jellyfin/config
              if [ ! -f "/var/lib/jellyfin/config/network.xml" ]; then
                echo '${strings.escape ["'"] content}' > /var/lib/jellyfin/config/network.xml
              fi
            ''
          );
        }
      );
  }
