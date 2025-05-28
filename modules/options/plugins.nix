{lib, ...}:
with lib; let
  pluginOptions = {
    name,
    config,
  }: {
    options = {
      name = mkOption {
        type = types.str;
        description = "The name of the plugin";
      };
      manifest = mkOption {
        type = types.strMatching "[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b([-a-zA-Z0-9()@:%_\\+.~#?&//=]*)";
        description = "Url location of the manifest.json for this plugin";
      };
      version = mkOption {
        type = types.nonEmptyString;
        description = "Which version of the plugin to download";
      };
      hash = mkOption {
        type = types.str;
        description = "sha-256 hash to match against the downloaded files";
      };
    };
  };
in {
  options.services.declarative-jellyfin.plugins = mkOption {
    type = with types; listOf (submodule pluginOptions);
    default = [
      {
        name = "TheTVDB";
        manifest = "https://repo.jellyfin.org/files/plugin/manifest.json";
        version = "19.0.0.0";
        hash = "sha256-3eVUtMgYggBB9S96S7AKsaPhinRiOztGOEEEGQcASws=";
      }
    ];
    description = "List of jellyfin plugins";
  };
}
