{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.declarative-jellyfin;
  toXml' = (import ../lib {nixpkgs = pkgs;}).toXMLGeneric;
  isStrList = x: all (x: isString x) x;
  prepass = x:
    if (isAttrs x)
    then
      if !(hasAttr "tag" x)
      then
        attrsets.mapAttrsToList
        (tag: value: {
          inherit tag;
          content = prepass value;
        })
        x
      else if (hasAttr "content" x)
      then {
        tag = x.tag;
        content = prepass x.content;
      }
      else x
    else if (isList x)
    then
      if (isStrList x)
      then
        (map
          (content: {
            tag = "string";
            inherit content;
          })
          x)
      else map prepass x
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
  imports = [
    ./options
  ];
  config =
    mkIf cfg.enable
    {
      system.activationScripts = {
        link-config-xml =
          lib.stringAfter ["var"]
          (
            let
              commands =
                concatStringsSep "\n"
                (map
                  (x: "cp -s \"${pkgs.writeText x.file (toXml x.name x.content)}\" \"/var/lib/jellyfin/config/${x.file}\"")
                  [
                    {
                      name = "NetworkConfiguration";
                      file = "network.xml";
                      content = cfg.network;
                    }
                    # {
                    #   name = "EncodingOptions";
                    #   file = "encoding.xml";
                    #   content = cfg.encoding;
                    # }
                    {
                      name = "ServerConfiguration";
                      file = "system.xml";
                      content = cfg.system;
                    }
                  ]);
            in ''
              mkdir -p "/var/lib/jellyfin/config"
              ${commands}
            ''
          );
      };
    };
}
