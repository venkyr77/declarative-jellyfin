#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash

nix-build documentation.nix
cat result > DOCUMENTATION.md
rm result
