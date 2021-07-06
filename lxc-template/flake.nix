{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Include the default lxd configuration.
        ./lxc-container.nix

        ({ pkgs, ... }: {
          # Install flakes
          nix.package = pkgs.nixUnstable;
          nix.extraOptions = ''
            experimental-features = nix-command flakes ca-references
          '';

          # Networking
          networking.useDHCP = false;
          networking.interfaces.eth0.useDHCP = true;
        })
      ];
    };
  };
}
