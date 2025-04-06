{pkgs ? import <nixpkgs> {}, ...}: let
  name = "minimal";
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
          ../modules/default.nix
        ];

        virtualisation.memorySize = 1024;

        environment.systemPackages = [
          pkgs.sqlite
        ];

        services.declarative-jellyfin = {
          enable = true;
          Users = [
            {
              Username = "admin";
              Password = "123";
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
        machine.succeed("file /var/lib/jellyfin/data/jellyfin.db")
        users = machine.succeed("sqlite3 /var/lib/jellyfin/data/jellyfin.db -- \"SELECT * FROM Users WHERE Username = 'admin'\"")
        print(users)
        if users == "":
          assert False, "User not in db"
      '';
  };
}
