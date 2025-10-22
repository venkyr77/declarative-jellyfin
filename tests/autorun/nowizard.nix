{pkgs ? import <nixpkgs> {}, ...}: let
  name = "nowizard";
  port = 8096;
in {
  inherit name;
  test = pkgs.nixosTest {
    inherit name;
    nodes = {
      ${name} = {...}: {
        imports = [
          ../../modules/default.nix
        ];

        virtualisation.memorySize = 1024;

        # Doesn't get more minimal than this
        services.declarative-jellyfin = {
          enable = true;
          network.publicHttpPort = port;
          system.isStartupWizardCompleted = true;
        };
      };
    };

    testScript =
      # py
      ''
        start_all()

        # Wait foreach node to run jellyfin-init
        for node in machines:
          node.wait_until_succeeds("test -e /var/log/jellyfin-init-done", timeout=120)

        # Give time for jellyfin to boot
        for node in machines:
          node.wait_until_succeeds("curl 127.0.0.1:${toString port}", timeout=60)

        # No errors should be reported in journal
        for node in machines:
          node.succeed("! journalctl --no-pager -b -u jellyfin.service | grep -v \"plugin\" | grep -q \"ERR\"")

        for node in machines:
          print("[" + node.succeed("hostname").strip() + "] " + "Jellyfin log: " + node.succeed("journalctl --no-pager -b -u jellyfin.service"))
      '';
  };
}
