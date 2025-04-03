{
  config,
  nixpkgs,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.declarative-jellyfin;
  toXml = (import ../../lib {inherit nixpkgs;}).toXMLGeneric;
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
          listOfStrPrepass = xml: (builtins.mapAttrs (name: value:
            (
              if ((name == "content") && (builtins.isList value))
              then
                if (builtins.all builtins.isString value)
                then # listOf str
                  (builtins.map (content: {
                    name = "string";
                    inherit content;
                  }))
                else # Lis of something else
                  warnIf (!(builtins.all builtins.isAttrs value)) "Recieved list of mixed values. This will most likely not evaluate correctly" (listOfStrPrepass value)
              else (listOfStrPrepass value)
            )
            xml));
          toXml = name: x: (toXml {
            inherit name;
            properties = {
              "xmlns:xsi" = "http://www.w3.org/2001/XMLSchema-instance";
              "xmlns:xsd" = "http://www.w3.org/2001/XMLSchema";
            };
            content = x;
          });
        in {
          system.activationScripts."link-network-xml" = lib.stringAfter ["var"] (
            let
              content = toXml "NetworkConfiguration" (listOfStrPrepass cfg.network);
            in ''
              ${pkgs.writeTextFile}/bin/writeTextFile /var/lib/jellyfin/config/network.xml '${strings.escape ["'"] content}'
            ''
          );
        }
      );
  }
