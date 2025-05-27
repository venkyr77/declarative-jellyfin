{pkgs ? import <nixpkgs> {}, ...}: let
  name = "createusers";
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

        environment.systemPackages = with pkgs; [
          sqlite
          file
        ];

        services.declarative-jellyfin = {
          enable = true;
          Users = {
            Admin = {
              Mutable = false;
              Password = "123";
              Permissions = {
                IsAdministrator = true;
                IsDisabled = false;
                # ...
              };
            };
            "Some cool user with spaces" = {
              Mutable = true;
              HashedPasswordFile = ../example_hash.txt;
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
        machine.wait_for_unit("jellyfin.service");
        machine.wait_until_succeeds("test -e /var/log/jellyfin-init-done", timeout=30)
        output = machine.succeed("cat /var/log/jellyfin.txt")
        print("Log: " + output)
        users = machine.succeed("sqlite3 /var/lib/jellyfin/data/jellyfin.db -- \"SELECT * FROM Users\"")
        print("Users: " + users)

        # TODO: loop over and check for every user
        if machine.succeed("sqlite3 /var/lib/jellyfin/data/jellyfin.db -- \"SELECT * FROM Users WHERE Username = 'Admin'\"") == "":
          assert False, "User not in db"
      '';
  };
}
