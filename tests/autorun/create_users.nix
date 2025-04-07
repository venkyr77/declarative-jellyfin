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
          Users = [
            {
              Username = "admin";
              Password = "123";
            }
            {
              Username = "other wierd user";
              HashedPasswordFile = ../example_hash.txt;
            }
          ];
        };
      };
    };

    testScript =
      /*
      py
      */
      ''
        machine.start()
        machine.wait_for_unit("multi-user.target");
        output = machine.succeed("cat /var/log/log.txt")
        print("Log: " + output)
        print(machine.succeed("cat /var/lib/jellyfin/data/jellyfin.db"))
        machine.succeed("file /var/lib/jellyfin/data/jellyfin.db")
        users = machine.succeed("sqlite3 /var/lib/jellyfin/data/jellyfin.db -- \"SELECT * FROM Users\"")
        print("Users: " + users)

        if machine.succeed("sqlite3 /var/lib/jellyfin/data/jellyfin.db -- \"SELECT * FROM Users WHERE Username = 'admin'\"") == "":
          assert False, "User not in db"
      '';
  };
}
