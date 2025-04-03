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
      };
    };

    testScript = ''
      machine.start()
      machine.wait_for_unit("multi-user.target");
    '';
  };
}
