{pkgs ? import <nixpkgs> {}, ...}:
pkgs.stdenv.mkDerivation rec {
  name = "genhash";
  version = "69.0.0";

  nativeBuildInputs = with pkgs; [
    gcc
    nettle
  ];

  phases = ["buildPhase"];

  buildPhase = ''
    mkdir -p $out
    gcc $src -o $out/${name} -lnettle
    echo $out
  '';

  src = ./pbkdf2-sha512.c;
}
