{pkgs ? import <nixpkgs> {}, ...}: let
  name = "verify-examples";
  exampleFiles =
    map (file: pkgs.lib.strings.removeSuffix ".nix" file) (builtins.attrNames (builtins.readDir ../../examples));
in {
  inherit name;
  test = pkgs.nixosTest {
    inherit name;
    # Generate a VM Node foreach example file config
    nodes = pkgs.lib.attrsets.genAttrs exampleFiles (
      example: {
        config,
        pkgs,
        ...
      }: {
        imports = [
          ../../modules/default.nix
          (import (../../examples + "/${example}.nix") {})
        ];

        virtualisation.memorySize = 1024;
      }
    );

    # Run the same test on each node VM
    testScript =
      /*
      py
      */
      ''
        start_all()
        for node in machines:
          node.wait_for_unit("jellyfin.service")

        for node in machines:
          node.succeed("ls -la /var/lib/jellyfin")
        for i in range(10):
          for node in machines:
            node.succeed("! journalctl --no-pager -b -u jellyfin.service | grep -v \"plugin\" | grep -q \"ERR\"")
            node.succeed("sleep 1")

        for node in machines:
          print("[" + node.execute("hostname")[1].strip() + "] " + "Jellyfin log: " + node.execute("journalctl --no-pager -b -u jellyfin.service")[1])

        for node in machines:
          node.succeed("curl 127.0.0.1:8096")
      '';
  };
}
