{
  description = "My NixOS configuration";

  inputs = {
    # Official NixOS package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    # Home Manager for user environment management
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
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
            home-manager.users.elliotxx = import ./users/elliotxx/home.nix;
          }
          
          # # Other modules
          # ./modules/packages.nix
          # ./modules/shell.nix
          # ./modules/home.nix
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