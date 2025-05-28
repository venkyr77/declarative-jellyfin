{lib, ...}:
with lib; {
  imports = [
    ./system.nix
    ./encoding.nix
    ./network.nix
    ./branding.nix
    ./users.nix
    ./libraries.nix
  ];
  options.services.declarative-jellyfin = {
    enable = mkEnableOption "Jellyfin Service";

    backups = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether or not to make a backup before we update jellyfin configs and DB.
        Disable at your own risk!
      '';
    };

    backupDir = mkOption {
      type = types.str;
      default = "/var/lib/jellyfin/backups";
      description = ''
        The directory to store backups
      '';
    };

    backupCount = mkOption {
      type = types.int;
      default = 5;
      description = ''
        The amount of backups that gets rotated, ie. how many backups to
        store before starting to delete old ones
      '';
    };
  };
}
