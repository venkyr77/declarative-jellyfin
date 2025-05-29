{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.services.declarative-jellyfin;
  in
with lib; with types; {
  imports = [
    ./system.nix
    ./encoding.nix
    ./network.nix
    ./branding.nix
    ./users.nix
    ./libraries.nix
    ./plugins.nix
  ];
  options.services.declarative-jellyfin = {
    enable = mkEnableOption "Jellyfin Service";

    # Jellyfin wrapped options
    user = mkOption {
      type = str;
      default = "jellyfin";
      description = "User account under which jellyfin runs";
    };

    group = mkOption {
      type = str;
      default = "jellyfin";
      description = "Group under which jellyfin runs";
    };
    dataDir = mkOption {
      type = path;
      default = "/var/lib/jellyfin";
      description = ''
        Base data directory,
        passed with `--datadir` see [#data-directory](https://jellyfin.org/docs/general/administration/configuration/#data-directory)
      '';
    };

    configDir = mkOption {
      type = path;
      default = "${cfg.dataDir}/config";
      defaultText = "\${cfg.dataDir}/config";
      description = ''
        Directory containing the server configuration files,
        passed with `--configdir` see [configuration-directory](https://jellyfin.org/docs/general/administration/configuration/#configuration-directory)
      '';
    };

    cacheDir = mkOption {
      type = path;
      default = "/var/cache/jellyfin";
      description = ''
        Directory containing the jellyfin server cache,
        passed with `--cachedir` see [#cache-directory](https://jellyfin.org/docs/general/administration/configuration/#cache-directory)
      '';
    };

    logDir = mkOption {
      type = path;
      default = "${cfg.dataDir}/log";
      defaultText = "\${cfg.dataDir}/log";
      description = ''
        Directory where the Jellyfin logs will be stored,
        passed with `--logdir` see [#log-directory](https://jellyfin.org/docs/general/administration/configuration/#log-directory)
      '';
    };

    openFirewall = mkOption {
      type = bool;
      default = false;
      description = ''
        Open the configured ports in the firewall for the media server. 
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.jellyfin;
      description = "Which package to use. Overrides `services.jellyfin.package`";
    };

    # Backup options
    backups = mkOption {
      type = bool;
      default = true;
      description = ''
        Whether or not to make a backup before we update jellyfin configs and DB.
        Disable at your own risk!
      '';
    };

    backupDir = mkOption {
      type = str;
      default = "/var/lib/jellyfin/backups";
      description = ''
        The directory to store backups
      '';
    };

    backupCount = mkOption {
      type = int;
      default = 5;
      description = ''
        The amount of backups that gets rotated, ie. how many backups to
        store before starting to delete old ones
      '';
    };
  };
}
