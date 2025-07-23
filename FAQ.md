# Frequently Asked Questions

## HDR Videos look washed out / has incorrect colours on non-HDR displays

```nix
services.declarative-jellyfin.encoding = {
    enableVppTonemapping = true;
    enableTonemapping = true;
    tonemappingAlgorithm = "bt2390"; # default
};
```
