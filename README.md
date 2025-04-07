# Declarative Jellyfin

This repository provides a nix flake that allows for declarative configuration of
Users, Libraries, Plugins, Settings, etc.

# Progress

- [x] Creating .xml files
- [x] Modifying databate
- [ ] Test cases
    - [x] XML Generation
    - [x] Networking
    - [ ] Encoding
    - [ ] System
    - [ ] Users
        - [x] Create users
        - [ ] Delete users
        - [ ] Insert users in middle (test InternalId)
        - [ ] MustUpdatePassword test
    - [ ] Libraries
    - [ ] Connecting
    - [ ] Fetching files

- [x] Users
    - [x] Hashed passwords
    - [ ] Mutable users (override Users table with configured users table if false, like in nixpkgs user-groups.nix)
- [ ] Libraries
- [ ] Plugins
- [ ] Settings
    - [ ] Scheduled jobs
    - [x] Networking
        - [x] Nix options
    - [x] Encoding
        - [x] Nix options
    - [x] System settings
        - [x] Nix options
    - [ ] Branding
        - [ ] Nix options

# Usage
## Setup
Add the flake to your `inputs` and import the `nixosModule` in your configuration.

Example minimal flake.nix:
```nix
{
  description = "An example using declarative-jellyfin flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    declarative-jellyfin.url = "gitlab:SpoodyTheOne/declarative-jellyfin";
    # optional follow:
    declarative-jellyfin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    declarative-jellyfin,
    ...
  }: {
    nixosConfigurations."your-hostname" = nixpkgs.lib.nixosSystem {
      modules = [
        declarative-jellyfin.nixosModules.default # <- this imports the NixOS module that provides the options
        ./configuration.nix # <- your host entrypoint
      ];
    };
  };
}
```
