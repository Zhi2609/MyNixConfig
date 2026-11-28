{
  description = "NixOS - MSI Katana 15 B13V | Gaming + Híbrido NVIDIA";

  inputs = {
    # Base del sistema y hardware
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Gestor de entorno de usuario
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Módulos y utilidades externas
    twintail-nix.url = "github:madebycli/twintail-nix";
    nixos-update-notifier = {
      url = "github:stuckj/nixos-update-notifier";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, twintail-nix, ... } @ inputs: {
    nixosConfigurations.Suisei = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        # --- Configuración base del sistema ---
        ./hardware-configuration.nix
        ./configuration.nix

        # --- Hardware específico (MSI / Intel Laptop) ---
        nixos-hardware.nixosModules.common-cpu-intel
        nixos-hardware.nixosModules.common-pc-laptop
        nixos-hardware.nixosModules.common-pc-laptop-ssd

        # --- Módulos externos ---
        twintail-nix.nixosModules.default
        {
          programs.twintaillauncher.enable = true;
        }

        # --- Home Manager ---
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            extraSpecialArgs = { inherit inputs; };
            users.zhi = import ./home.nix;
          };
        }
      ];
    };
  };
}
