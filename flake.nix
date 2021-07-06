{
  description = "A very basic flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";

  outputs = { self, nixpkgs }: {
    nixosConfigurations.lxc = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =[
        ({ pkgs, ... }: {
          imports = [
            ./lxc-container.nix
          ];

          # Install flakes
          nix.package = pkgs.nixUnstable;
          nix.extraOptions = ''
            experimental-features = nix-command flakes ca-references
          '';

          # Copy the config for nixos-rebuild
          system.activationScripts.config = ''
            if [ ! -e /etc/nixos/configuration.nix ]; then
              mkdir -p /etc/nixos
              cat ${./lxc-container.nix} > /etc/nixos/lxc-container.nix
              cat ${./configuration.nix} > /etc/nixos/configuration.nix
            fi
          '';
          
          # Make lxc exec work properly
          system.activationScripts.bash = ''
            mkdir -p /bin
            ln -sf /run/current-system/sw/bin/bash /bin/bash
          '';

          # Network
          networking.useDHCP = false;
          networking.interfaces.eth0.useDHCP = true;
        })
      ];
    };
  };
}
