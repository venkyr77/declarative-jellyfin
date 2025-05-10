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
        - [ ] Mutable flag
        - [ ] Make sure REPLACE will use existing user id primary key on multiple rebuilds
    - [ ] Libraries
    - [ ] Connecting
    - [ ] Fetching files

- [x] Users
    - [x] Hashed passwords
    - [x] Mutable users
    - [ ] Global flag to disable new users (users in DB but not specified in config will be deleted)
    - [x] User permissions
- [ ] Final Integrity Checks
    - [ ] Check all users exists
    - [ ] Verify libraries
    - [ ] Warn user
    - [ ] Restore backup
    - [ ] Fail activation script
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
    declarative-jellyfin.url = "git+https://git.spoodythe.one/spoody/declarative-jellyfin.git";
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

## Generate user password hash
Use the `genhash` script bundled in this flake with the parameters the jellyfin DB expects:
```nix
nix run git+https://git.spoodythe.one/spoody/declarative-jellyfin.git#genhash -- -i 210000 -l 128 -u -k "your super secret password"
```

## Usage with sops-nix
First make sure that sops extracts secrets before the declarative-jellyfin activationScript runs.
Add this to your `configuration.nix`:
```nix
system.activationScripts.create-db.deps = ["setupSecrets"];
```

Then just extract the secret and use the `HashedPasswordFile`:
```nix
sops.secrets.example-user-password = {
    owner = config.services.jellyfin.user;
    group = config.services.jellyfin.group;
};
services.declarative-jellyfin.Users.example-user.HashedPasswordFile = config.sops.secrets.example-user-password.path;
```
