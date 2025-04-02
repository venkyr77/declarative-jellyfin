{nixpkgs, ...}:
nixpkgs.lib.extend (
  final: prev: {
    toXMLGeneric = let
      toXMLRecursive =
        toXmlRecursive'
        "<?xml version='1.0' encoding='utf-8'?>";

      toXmlRecursive' = str: xml: let
        parseTag = str: xml: (builtins.concatStringsSep "" [
          str
          "\n"
          "<${xml.name}"

          (
            if (builtins.hasAttr "properties" xml)
            then
              (" "
                + builtins.concatStringsSep " " (nixpkgs.lib.attrsets.mapAttrsToList
                  (name: value: "${name}=\"${nixpkgs.lib.strings.escapeXML value}\"")
                  xml.properties))
            else ""
          )

          (
            if builtins.hasAttr "content" xml
            then ((toXmlRecursive' "" xml.content) + "\n</${xml.name}>")
            else "/>"
          )
        ]);
        output =
          if (builtins.isAttrs xml)
          then (parseTag str xml)
          else if (builtins.isList xml)
          then (builtins.concatStringsSep "\n" (builtins.map (x: (toXmlRecursive' "" x)) xml))
          else if ((builtins.isBool xml) || (builtins.isInt xml) || (builtins.isNull xml) || (builtins.isFloat xml))
          then (builtins.toString xml)
          else nixpkgs.lib.abort "Cannot convert a ${builtins.typeOf xml} to XML";
      in
        output;
    in
      toXMLRecursive;
  }
)
