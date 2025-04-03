{pkgs ? import <nixpkgs> {}, ...}: let
  name = "networking";
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

        services.declarative-jellyfin = {
          enable = true;
          network = {
            PublishedServerUriBySubnet = [
              "all=https://test.test.test"
            ];
          };
        };
      };
    };

    # stfu i dont care about python linting
    skipLint = true;

    testScript = ''
      import xml.etree.ElementTree as ET

      machine.start()
      machine.wait_for_unit("multi-user.target");

      with subtest("Jellyfin URI"):
        machine.succeed("ls /var/lib/jellyfin")
        tree = ET.parse("/var/lib/jellyfin/config/network.xml")
        root = tree.getroot()
        found = False
        for child in root:
          if child.tag == "PublishedServerUriBySubnet":
            found = True
            print(child)
            assert False
    '';
  };
}
