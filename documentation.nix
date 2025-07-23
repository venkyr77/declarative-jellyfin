{
  nixpkgs ? import <nixpkgs> { },
}:
with nixpkgs.lib;
let
  repeat' =
    t: c: i:
    if i == 0 then t else repeat' (t + c) c (i - 1);
  repeat = repeat' "";

  toStringDoc' =
    depth:
    let
      d0 = x: if depth == 0 then x else "";
    in
    value:
    if builtins.isString value then
      # TODO: Prettier multiline strings
      "${d0 "`"}\"${value}\"${d0 "`"}"
    else if builtins.isBool value then
      "${d0 "`"}${trivial.boolToString value}${d0 "`"}"
    else if builtins.isInt value || builtins.isFloat value then
      "${d0 "`"}${toString value}${d0 "`"}"
    else if builtins.isList value then
      if builtins.length value == 0 then
        "${d0 "`"}[]${d0 "`"}"
      else
        ''
          ${d0 ''

            ```nix
          ''}[
          ${builtins.concatStringsSep "\n" (
            builtins.map (x: (repeat " " (depth+1)) + (toStringDoc' (depth + 1) x)) value
          )}
          ${repeat " " depth}]${d0 "\n```"}''
    else if builtins.isAttrs value then
      ''
        ${d0 ''

          ```nix
        ''}{
        ${builtins.concatStringsSep "\n" (
          attrsets.mapAttrsToList (k: v: "${repeat " " (depth+1)}${k} = ${toStringDoc' (depth + 1) v};") value
        )}
        ${repeat " " depth}}${d0 "\n```"}''
    else
      "`<${builtins.typeOf value}>`";
  toStringDoc = toStringDoc' 0;

  makeDocumentationRecursive =
    depth: fqn: option:
    "${repeat "#" (depth + 1)} ${fqn}\n"
    + (
      if builtins.hasAttr "_type" option then
        if option.type.name == "attrsOf" then
          makeDocumentationRecursive (depth + 1) "${fqn}.*" (
            builtins.removeAttrs (option.type.nestedTypes.elemType.getSubOptions { }) [ "_module" ]
          )
        else if option.type.name == "submodule" then
          builtins.concatStringsSep "\n" (
            attrsets.mapAttrsToList (k: v: makeDocumentationRecursive (depth + 1) "${fqn}.${k}" v) (
              builtins.removeAttrs (option.type.getSubOptions { }) [ "_module" ]
            )
          )
        else
          ''
            ${if builtins.hasAttr "description" option then option.description + "\n" else ""}
            **Type**: ${option.type.description}
            ${if builtins.hasAttr "default" option then "\n**Default**: ${toStringDoc option.default}" else ""}
          ''
      else
        builtins.concatStringsSep "\n" (
          attrsets.mapAttrsToList (k: v: makeDocumentationRecursive (depth + 1) "${fqn}.${k}" v) option
        )
    );
in
nixpkgs.writeTextFile (
  let
    modules = [
      {
        name = "services.declarative-jellyfin.system";
        options =
          (import ./modules/options/system.nix {
            lib = nixpkgs.lib;
            config = {
              networking.hostName = "config.networking.hostName";
            };
          }).options.services.declarative-jellyfin.system;
      }
      {
        name = "services.declarative-jellyfin.libraries";
        options =
          (import ./modules/options/libraries.nix {
            lib = nixpkgs.lib;
            config = {
              networking.hostName = "config.networking.hostName";
            };
          }).options.services.declarative-jellyfin.libraries;
      }
      {
        name = "services.declarative-jellyfin.encoding";
        options =
          (import ./modules/options/encoding.nix {
            lib = nixpkgs.lib;
            config = {
              networking.hostName = "config.networking.hostName";
            };
            pkgs = nixpkgs;
          }).options.services.declarative-jellyfin.encoding;
      }
      {
        name = "services.declarative-jellyfin.network";
        options =
          (import ./modules/options/network.nix {
            lib = nixpkgs.lib;
            config = {
              networking.hostName = "config.networking.hostName";
            };
            pkgs = nixpkgs;
          }).options.services.declarative-jellyfin.network;
      }
      # Uncomment when i stop being too lazy to fix plugins
      # {
      #   name = "services.declarative-jellyfin.plugins";
      #   options =
      #     (import ./modules/options/plugins.nix {
      #       lib = nixpkgs.lib;
      #       config = {
      #         networking.hostName = "config.networking.hostName";
      #       };
      #       pkgs = nixpkgs;
      #     }).options.services.declarative-jellyfin.plugins;
      # }
      {
        name = "services.declarative-jellyfin.users";
        options =
          (import ./modules/options/users.nix {
            lib = nixpkgs.lib;
            config = {
              networking.hostName = "config.networking.hostName";
            };
            pkgs = nixpkgs;
          }).options.services.declarative-jellyfin.users;
      }
    ];
  in
  {
    name = "documentation.md";
    text = builtins.foldl' (
      a: b: a + (makeDocumentationRecursive 0 b.name b.options)
    ) "This documentation is auto-generated\n" modules;
  }
)
