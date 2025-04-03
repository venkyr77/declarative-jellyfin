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

        # assertions = let
        #   toXml = (import ../lib {nixpkgs = pkgs;}).toXMLGeneric;
        # in [
        #   {
        #     assertion =
        #       toXml {tag = "test";}
        #       == ''
        #         <?xml version='1.0' encoding='utf-8'?>
        #         <test />
        #
        #       '';
        #     message = "Generated XML is incorrect!";
        #   }
        #   {
        #     assertion = false;
        #     message = "lmao";
        #   }
        # ];

        ass = false;

        virtualisation.memorySize = 1024 * 2;

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

    testScript = ''
      import xml.etree.ElementTree as ET

      machine.wait_for_unit("multi-user.target");

      with subtest("Networking"):
        # stupid fucking hack because you cant open files in python for some reason
        xml = machine.succeed("cat /var/lib/jellyfin/config/network.xml")
        tree = ET.ElementTree(ET.fromstring(xml))
        root = tree.getroot()
        for child in root:
          if child.tag == "PublishedServerUriBySubnet":
            try:
              if child[0].text == "all=https://test.test.test":
                break
            except:
              print("An error occured when trying to parse xml")
              print(xml)
              assert False, "Exception occured, check output above"
        else:
          assert False, "The shit was not found"

      machine.shutdown()
    '';
  };
}
