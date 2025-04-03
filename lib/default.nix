{ nixpkgs, ... }:
{
  toXMLGeneric =
    let
      toXMLRecursive =
        toXmlRecursive'
          "<?xml version='1.0' encoding='utf-8'?>\n"
          0;

      indent = depth: (
        if (depth <= 0)
        then ""
        else ("  " + (indent (depth - 1)))
      );

      toXmlRecursive' = str: depth: xml:
        let
          parseTag = str: depth: xml: (builtins.concatStringsSep "" [
            str
            "${indent depth}<${xml.name}${
            if (builtins.hasAttr "content" xml)
            then ">"
            else " "
          }"

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
              then ((toXmlRecursive' "\n" (depth + 1) xml.content) + "</${xml.name}>")
              else "/>"
            )
          ]);
        in
        if (builtins.isAttrs xml)
        then "${parseTag str depth xml}\n${indent (depth - 1)}"
        else if (builtins.isList xml)
        then "\n${(builtins.concatStringsSep "" (builtins.map (x: (toXmlRecursive' "" depth x)) xml))}${indent (depth - 1)}"
        else if ((builtins.isBool xml) || (builtins.isInt xml) || (builtins.isNull xml) || (builtins.isFloat xml))
        then (builtins.toString xml)
        else if (builtins.isString xml)
        then xml
        else throw "Cannot convert a ${builtins.typeOf xml} to XML";
    in
    toXMLRecursive;
}

