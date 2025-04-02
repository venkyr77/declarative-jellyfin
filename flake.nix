{
  description = "Declarative jellyfin with more options";
  inputs = {};
  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  in {
    formatter = forAllSystems (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in
        pkgs.alejandra
    );
    nixosModules = rec {
      declarative-jellyfin = import ./module.nix;
      default = declarative-jellyfin;
    };
    nixosModule = self.nixosModules.default; # compatiblilty
  };
}
