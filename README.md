# NixOS LXC Container
Run NixOS container in lxc.

This flake provides a configuration to build a NixOS image for use with [LXC](https://linuxcontainers.org/).

<!-- TODO add things about deploy-rs and ssh -->


## Prerequisites
- Install [nixos-generators](https://github.com/nix-community/nixos-generators):
    ```
    nix shell github:nix-community/nixos-generators
    ```
- Enable lxd by adding `virtualisation.lxd.enable = true;` to your NixOS configuration.

- And initialize it with `lxd init` - it will guid you with various settings.

## Running a NixOS container
Generate an image for lxd:
```
lxc image import --alias nixos \
$(nixos-generate -f lxc-metadata) \
$(nixos-generate --flake github:torx-cz/nixos-lxc-container#lxc -f lxc)
```

Launch a container:
```
lxc launch nixos nixos-container -c security.nesting=true
```

Access its root shell:
```
lxc exec nixos-container bash
```
