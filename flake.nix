{
  description = "My NixOS configuration";

  inputs = {
    # Official NixOS package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    # Home Manager for user environment management
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    # NixOS configuration entry point
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # Replace with your hostname
      nixos = nixpkgs.lib.nixosSystem {
        # To check your system architecture:
        # - Run 'uname -m' in terminal
        # - x86_64 -> x86_64-linux
        # - aarch64 -> aarch64-linux
        # Architecture: ARM 64-bit (Apple Silicon, Raspberry Pi 4, etc.)
        system = "aarch64-linux";
        modules = [
          # Main system configuration
          ./configuration.nix
          
          # Home Manager configuration
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.elliotxx = { lib, ... }: {
              home.homeDirectory = lib.mkForce "/home/elliotxx";
              imports = [ ./users/elliotxx/home.nix ];
            };
          }
        ];
      };
    };

    # Development shell
    # Available through 'nix develop'
    devShell.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.mkShell {
      buildInputs = with nixpkgs.legacyPackages.aarch64-linux; [
        git
        nixpkgs-fmt
      ];
    };
  };
}