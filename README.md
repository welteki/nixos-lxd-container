# NixOS LXD Containers
Run NixOS containers in lxd.

This flake provides a configuration to build a NixOS image for use with LXD.

> The configuration takes some settings from [this pull request](https://github.com/NixOS/nixpkgs/pull/120965) by [mkg20001](https://github.com/mkg20001) awaiting its merge.


## Prerequisites
- Install [nixos-generators](https://github.com/nix-community/nixos-generators):
    ```
    nix shell github:nix-community/nixos-generators
    ```
- Enable lxd by adding `virtualisation.lxd.enable = true;` to your NixOS configuration.

## Running a NixOS container
Generate an image for lxd:
```
lxc image import --alias nixos \
$(nixos-generate -f lxc-metadata) \
$(nixos-generate --flake github:welteki/nixos-lxd-container#lxc -f lxc)
```

Launch a container:
```
lxc launch nixos nixos-container -c security.nesting=true
```

Access its root shell:
```
lxc exec nixos-container -- /bin/bash
```
