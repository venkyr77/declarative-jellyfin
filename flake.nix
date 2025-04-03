{
  description = "Declarative jellyfin with more options";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    forAllSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];

    # Create a test for every file in `tests/`
    tests = system:
      builtins.listToAttrs (builtins.map
        (x: let
          test = import (./tests + "/${x}") {pkgs = import nixpkgs {inherit system;};};
        in {
          name = test.name;
          value = test.test;
        })
        (
          builtins.filter (x: x != null) ((nixpkgs.lib.attrsets.mapAttrsToList (name: value:
            if value == "regular"
            then name
            else null))
          (builtins.readDir ./tests))
        ));
  in {
    formatter = forAllSystems (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in
        pkgs.alejandra
    );
    nixosModules = rec {
      declarative-jellyfin = import ./modules;
      default = declarative-jellyfin;
    };

    # Run all tests for all systems
    hydraJobs = forAllSystems tests;
    checks = forAllSystems tests;
  };
}
