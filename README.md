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
