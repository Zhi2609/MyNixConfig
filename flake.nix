{
  description = "NixOS - MSI Katana 15 B13V | Gaming + Híbrido NVIDIA";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    twintail-nix.url = "github:madebycli/twintail-nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, twintail-nix, ... } @ inputs: {
    nixosConfigurations.Suisei = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ({ config, ... }: {
          nixpkgs.overlays = [
            inputs.antigravity-nix.overlays.default
          ];
        })

        twintail-nix.nixosModules.default
        {
          programs.twintaillauncher.enable = true;
        }

        ./hardware-configuration.nix
        ./configuration.nix

        nixos-hardware.nixosModules.common-cpu-intel
        nixos-hardware.nixosModules.common-pc-laptop
        nixos-hardware.nixosModules.common-pc-laptop-ssd

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.zhi = import ./home.nix;
        }
      ];
    };
  };
}
