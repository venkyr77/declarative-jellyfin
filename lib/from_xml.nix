{nixpkgs, ...}:
nixpkgs.lib.extend (
  final: prev: {
    fromXml = {
    };
  }
)
