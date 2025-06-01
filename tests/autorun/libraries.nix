{pkgs ? import <nixpkgs> {}, ...}: let
  name = "libraries";
  port = 8096;
in {
  inherit name;
  test = pkgs.nixosTest {
    inherit name;
    nodes = {
      machine = {
        config,
        pkgs,
        ...
      }: {
        imports = [
          ../../modules/default.nix
        ];

        virtualisation.memorySize = 1024;

        system.activationScripts.setupFolders =
          /*
          bash
          */
          ''
            mkdir -p /data/Movies
            mkdir -p /data/Shows
            mkdir -p /data/Pictures
            mkdir -p /data/Videos
            mkdir -p /data/Books
            mkdir -p /data/Music
          '';

        services.declarative-jellyfin = {
          network.PublicHttpPort = port;
          enable = true;
          system.IsStartupWizardCompleted = true;
          openFirewall = true;
          Users = {
            admin = {
              Password = "admin";
              Permissions = {
                IsAdministrator = true;
              };
            };
          };
          libraries = {
            Movies = {
              Enabled = true;
              ContentType = "movies";
              PathInfos = ["/data/Movies"];
            };
            Shows = {
              Enabled = true;
              ContentType = "tvshows";
              PathInfos = ["/data/Shows"];
            };
            "Photos and videos" = {
              Enabled = true;
              ContentType = "homevideos";
              PathInfos = ["/data/Pictures" "/data/Videos"];
            };
            Books = {
              Enabled = true;
              ContentType = "books";
              PathInfos = ["/data/Books"];
            };
            Music = {
              Enabled = true;
              ContentType = "music";
              PathInfos = ["/data/Music"];
            };
          };
        };
      };
    };

    testScript =
      /*
      py
      */
      ''
        machine.start()
        machine.wait_until_succeeds("test -e /var/log/jellyfin-init-done", timeout=120)
        machine.wait_until_succeeds("curl 127.0.0.1:8096", timeout=60)
        machine.succeed("! journalctl --no-pager -b -u jellyfin.service | grep -v \"plugin\" | grep -q \"ERR\"")
        # TODO: use api key to test that libraries are there
      '';
  };
}
