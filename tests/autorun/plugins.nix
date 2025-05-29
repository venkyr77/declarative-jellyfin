{pkgs ? import <nixpkgs> {}, ...}: let
  name = "plugins";
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

        services.declarative-jellyfin = {
          enable = true;
          network.PublicHttpPort = port;
          plugins = [
            {
              name = "intro skipper";
              url = "https://github.com/intro-skipper/intro-skipper/releases/download/10.10/v1.10.10.19/intro-skipper-v1.10.10.19.zip";
              version = "1.10.10.19";
              targetAbi = "10.10.7.0";
              sha256 = "sha256:12hby8vkb6q2hn97a596d559mr9cvrda5wiqnhzqs41qg6i8p2fd";
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
        machine.wait_for_unit("jellyfin.service");
        machine.wait_until_succeeds("test -e /var/log/jellyfin-init-done", timeout=120)
        output = machine.succeed("cat /var/log/jellyfin.txt")
        print("Log: " + output)

        # Give 10 seconds for jellyfin to boot
        for node in machines:
          node.wait_until_succeeds("curl 127.0.0.1:${toString port}", timeout=10)

        # print log for debugging
        print(machine.execute("journalctl --no-pager -b -u jellyfin.service")[1])

        # Should be able to curl it
        machine.succeed("curl 127.0.0.1:${toString port}")

        # intro skipper folder should be created
        for node in machines:
          node.wait_until_succeeds("test -e '/var/lib/jellyfin/plugins/intro skipper_1.10.10.19'", timeout=30)
      '';
  };
}
