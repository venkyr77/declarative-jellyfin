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
        #   (
        #     let
        #       xml =
        #         toXml {tag = "test";};
        #       expected = ''
        #         <?xml version='1.0' encoding='utf-8'?>
        #         <test />
        #       '';
        #     in {
        #       assertion = xml == expected;
        #       message = "Generated XML is incorrect!\nExpected \n\n${expected}\n\n but got \n\n${xml}\n";
        #     }
        #   )
        # ];

        assertions = let
          genTest = name: expected: got: {
            assertion = expected == got;
            message = "[Test: ${name}] Generated XML is incorrect!\nExpected \n\n${expected}\n but got \n\n${got}";
          };
          toXml = (import ../lib {nixpkgs = pkgs;}).toXMLGeneric;
        in [
          (
            genTest "Single tag"
            ''
              <?xml version='1.0' encoding='utf-8'?>
              <test />
            ''
            (toXml {tag = "test";})
          )
          (
            genTest "Single inner tag"
            ''
              <?xml version='1.0' encoding='utf-8'?>
              <test>
                <inner />
              </test>
            ''
            (toXml {
              tag = "test";
              content = {tag = "inner";};
            })
          )
          (
            genTest "Tag with string"
            ''
              <?xml version='1.0' encoding='utf-8'?>
              <test>stringstringstring</test>
            ''
            (toXml {
              tag = "test";
              content = "stringstringstring";
            })
          )
          (
            genTest "Empty string"
            ''
              <?xml version='1.0' encoding='utf-8'?>
              <test />
            ''
            (toXml {
              tag = "test";
              content = "";
            })
          )
          (
            genTest "List of tags"
            ''
              <?xml version='1.0' encoding='utf-8'?>
              <test>
                <tag0 />
                <tag1 />
                <tag2 />
                <tag3 />
                <tag4 />
                <tag5 />
                <tag6 />
                <tag7 />
                <tag8 />
              </test>
            ''
            (toXml {
              tag = "test";
              content = builtins.genList (x: {tag = "tag${toString x}";}) 9;
            })
          )
          (
            genTest "Empty list"
            ''
              <?xml version='1.0' encoding='utf-8'?>
              <test />
            ''
            (toXml {
              tag = "test";
              content = [];
            })
          )
          (
            genTest "bool value true"
            ''
              <?xml version='1.0' encoding='utf-8'?>
              <test>true</test>
            ''
            (toXml {
              tag = "test";
              content = true;
            })
          )
          (
            genTest "bool value false"
            ''
              <?xml version='1.0' encoding='utf-8'?>
              <test>false</test>
            ''
            (toXml {
              tag = "test";
              content = false;
            })
          )
        ];

        virtualisation.memorySize = 1024;

        services.declarative-jellyfin = {
          enable = true;
          network = {
            PublishedServerUriBySubnet = [
              "all=https://test.test.test"
            ];
            EnableHttps = true;
            RequireHttps = true;
            CertificatePath = "/path/to/cert";
          };
        };
      };
    };

    testScript = ''
      import xml.etree.ElementTree as ET

      machine.wait_for_unit("multi-user.target");

      with subtest("network.xml"):
        # stupid fucking hack because you cant open files in python for some reason
        xml = machine.succeed("cat /var/lib/jellyfin/config/network.xml")
        tree = ET.ElementTree(ET.fromstring(xml))
        root = tree.getroot()

        with subtest("PublishedServerUriBySubnet"):
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
            assert False, "The shit was not found. Full XML: " + xml

        with subtest("EnableHttps"):
          for child in root:
            if child.tag == "EnableHttps":
              if child.text == "true":
                break
          else:
            assert False, "The shit was not found. Full XML: " + xml

        with subtest("RequireHttps"):
          for child in root:
            if child.tag == "RequireHttps":
              if child.text == "true":
                break
          else:
            assert False, "The shit was not found. Full XML: " + xml

      machine.shutdown()
    '';
  };
}
