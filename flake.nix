{
  description = "NixOS lxd container configuration";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";

  outputs = { self, nixpkgs }: {
    nixosConfigurations.lxc = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =[
        ({ pkgs, ... }: {
          imports = [
            ./lxc-template/lxc-container.nix
          ];

          # Install flakes
          nix.package = pkgs.nixUnstable;
          nix.extraOptions = ''
            experimental-features = nix-command flakes ca-references
          '';

          # Copy the config for nixos-rebuild
          system.activationScripts.config = ''
            if [ ! -e /etc/nixos/flake.nix ]; then
              mkdir -p /etc/nixos
              cat ${./lxc-template/lxc-container.nix} > /etc/nixos/lxc-container.nix
              cat ${./lxc-template/flake.nix} > /etc/nixos/flake.nix
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

    templates.lxc-container = {
      path = ./lxc-template;
      description = "Minimal NixOS host configuration for lxd container.";
    };

    defaultTemplate = self.templates.lxc-container;
  };
}
