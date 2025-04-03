{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.declarative-jellyfin;
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
        (builtins.map
          (content: {
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
  config =
    mkIf cfg.enable
    {
      system.activationScripts = {
        link-config-xml =
          lib.stringAfter ["var"]
          (
            let
              commands =
                builtins.concatStringsSep "\n"
                (builtins.map
                  (x: "cp -s \"${pkgs.writeText x.file (toXml x.name x.content)}\" \"/var/lib/jellyfin/config/${x.file}\"")
                  [
                    {
                      name = "NetworkConfiguration";
                      file = "network.xml";
                      content = cfg.network;
                    }
                    {
                      name = "EncodingOptions";
                      file = "encoding.xml";
                      content = cfg.encoding;
                    }
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
