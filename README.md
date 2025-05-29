# Declarative Jellyfin
![workflows badge](https://git.spoodythe.one/spoody/declarative-jellyfin/badges/workflows/run-tests.yml/badge.svg)
![issues badge](https://git.spoodythe.one/spoody/declarative-jellyfin/badges/issues.svg)

This repository provides a nix flake that allows for declarative configuration of
Users, Libraries, Plugins, Settings, etc.

# Features
* Declarative users
    * passwords + hashed passwords
    * permissions
* Server Settings
    * System
    * Network
    * Encoding (HW acceleration)
* Declarative plugins (no way to configure them yet though)
* Libraries (photo libraries currently doesn't work)
<!-- * Backup (in case we corrupt the db >=<) -->

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
## Hardware Acceleration
First figure out what HW acceleration methods your system supports: https://jellyfin.org/docs/general/post-install/transcoding/hardware-acceleration/

Then configure the options through `services.declarative-jellyfin.encoding`.

### Example with AMD VA-API:
```nix
# AMD VA-API and VDPAU should work out of the box with mesa
hardware.graphics.enable = true;
users.users.${config.services.jellyfin.user}.extraGroups = ["video" "render"];

services.declarative-jellyfin = {
    # ... other configuration ...
    encoding = {
      EnableHardwareEncoding = true;
      HardwareAccelerationType = "vaapi";
      EnableDecodingColorDepth10Hevc = true; # enable if your system supports
      AllowHevcEncoding = true; # enable if your system supports
      AllowAv1Encoding = true; # enable if your system supports
      HardwareDecodingCodecs = [ # enable the codecs your system supports
        "h264"
        "hevc"
        "mpeg2video"
        "vc1"
        "vp9"
        "av1"
      ];
    };
};
```
Use `vainfo` from `libva-utils` to see the codec capabilities for your VA-API device.

## Plugins

Installed plugins can be configured declaratively using the `declarative-jellyfin.plugins` attribute.

```nix
services.declarative-jellyfin = {
    enable = true;
    plugins = [
        {
            name = "intro skipper";
            url = "https://github.com/intro-skipper/intro-skipper/releases/download/10.10/v1.10.10.19/intro-skipper-v1.10.10.19.zip";
            version = "1.10.10.19";
            targetAbi = "10.10.7.0"; # Required as intro-skipper doesn't provide a meta.json file
            sha256 = "sha256:12hby8vkb6q2hn97a596d559mr9cvrda5wiqnhzqs41qg6i8p2fd";
        }
    ];
};
```

This will download the specified verson of the plugin and install it for you during evaluation.

### Configuring plugins

This is still not possible, but is being worked on.

## Migrating from existing config

Declarative Jellyfin is designed to be a drop-in replacement for the normal jellyfin service.

```diff
- services.jellyfin = {
+ services.declarative-jellyfin = {
```

## Generate user password hash
Jellyfin uses pbkdf2-sha512 hashes to store passwords.
Use the `genhash` script bundled in this flake with the parameters the jellyfin DB expects:
```nix
nix run git+https://git.spoodythe.one/spoody/declarative-jellyfin.git#genhash -- -i 210000 -l 128 -u -k "your super secret password"
```

## Usage with sops-nix
Extract the secret and use the `HashedPasswordFile`:
```nix
sops.secrets.example-user-password = {
    owner = config.services.jellyfin.user;
    group = config.services.jellyfin.group;
};
services.declarative-jellyfin.Users.example-user.HashedPasswordFile = config.sops.secrets.example-user-password.path;
```
