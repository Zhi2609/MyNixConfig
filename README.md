# MyNixConfig

Configuración declarativa de NixOS para **MSI Katana 15 B13V** (hostname: Suisei).

Repositorio personal que define desde cero mi entorno de trabajo y gaming usando [NixOS](https://nixos.org/) + [ flakes](https://nixos.wiki/wiki/Flakes) + [home-manager](https://github.com/nix-community/home-manager).

## Requisitos

- NixOS con flakes habilitados (`nix.settings.experimental-features = [ "nix-command" "flakes" ]`)
- Conexión a internet (la primera vez descarga todo desde caché)

## Uso

### Construcción inicial (desde ISO o instalación limpia)

```bash
# Clonar en /etc/nixos (o donde tengas la config)
sudo git clone https://github.com/<tu-usuario>/MyNixConfig /etc/nixos

# Construir y cambiar al nuevo sistema
sudo nixos-rebuild switch --flake /etc/nixos#Suisei
```

### Reconstruir después de cambios

```bash
sudo nixos-rebuild switch --flake /etc/nixos#Suisei
```

### Limpiar el store (borrar generaciones viejas)

```bash
sudo nix-collect-garbage -d && sudo nixos-rebuild boot --flake /etc/nixos#Suisei
```

## Estructura del repositorio

```
.
├── flake.nix                  # Entry point del flake
│   ├── inputs: nixpkgs (unstable), nixos-hardware, home-manager
│   └── outputs: configuración "Suisei" para x86_64-linux
│
├── configuration.nix          # Configuración del sistema (NixOS)
│   ├── Boot: systemd-boot, kernel params
│   ├── Red: hostname, networkmanager, firewall
│   ├── Display: SDDM + Plasma 6 + Niri
│   ├── Usuario: zhi, sudo, polkit
│   ├── Paquetes base: git, curl, btop, fastfetch, etc.
│   ├── Fonts: MesloLG, FiraCode, JetBrains Mono, Nerd Fonts
│   ├── Shell: zsh (global), dconf
│   ├── XDG Portal: GTK backend
│   ├── Nix: cachix, auto-optimise, GC semanal
│   └── Variables de entorno: Wayland, NVIDIA
│
├── home.nix                   # Configuración de usuario (home-manager)
│   └── imports: todos los módulos de modules/user/
│
└── modules/
    ├── system/                # Módulos de sistema (NixOS)
    │   │
    │   ├── hardware.nix       # NVIDIA optimus (offload), gráficos Intel, zram
    │   │   ├── Kernel: nvidia_drm.modeset, iommu
    │   │   ├── Graphics: Intel media driver + VA-API, NVIDIA proprietario
    │   │   ├── NVIDIA Prime: offload por defecto, sync en especialización "performance"
    │   │   └── zram: 50% de RAM, zstd
    │   │
    │   ├── gaming.nix         # Gaming optimizations
    │   │   ├── Kernel: CachyOS, preempt=full
    │   │   ├── Steam + gamescope session
    │   │   ├── Gamemode
    │   │   └── Variables: PROTON_ENABLE_NVAPI, DXVK_ASYNC
    │   │
    │   └── services.nix       # Servicios del sistema
    │       ├── Pipewire (audio, ALSA, Pulse, JACK)
    │       ├── Bluetooth (encendido al boot)
    │       ├── TLP (performance en AC, powersave en batería)
    │       ├── Thermald
    │       ├── Flatpak
    │       └── Fstrim (SSD)
    │
    └── user/                  # Módulos de usuario (home-manager)
        │
        ├── core.nix           # Configuración base del usuario
        │   ├── Username: zhi
        │   ├── XDG directories: Escritorio, Documentos, Descargas, etc.
        │   ├── GTK theme: Layan-Dark + Papirus-Dark + Adwaita
        │   └── Dconf: preferencia oscura global
        │
        ├── apps.nix           # Paquetes y programas de usuario
        │   ├── Web: Firefox, Brave
        │   ├── Chat: Telegram, Vesktop
        │   ├── Dev: VS Code, JetBrains Toolbox, Node.js, JDK 25, Pandoc
        │   ├── Gaming: Heroic, Lutris, MangoHud, ProtonPlus
        │   ├── Office: LibreOffice, OnlyOffice, MasterPDF, PDF Arranger
        │   ├── Multimedia: Krita, VLC, Flameshot, Upscayl
        │   ├── Virtualización: virt-manager
        │   └── CLI: Yazi, nixfmt
        │   ├── MangoHud config (top-left, metrics varias)
        │   └── Git config (usuario, default branch main)
        │
        ├── shell.nix          # Zsh shell
        │   ├── oh-my-zsh: tema kphoen
        │   ├── Plugins: git, sudo, z, history, docker
        │   ├── Aliases: rebuild, upgrade, gcclean, game, ll, git, etc.
        │   └── init: HISTSIZE, fastfetch al arrancar
        │
        └── xdgParameters.nix  # Asociaciones y entradas de escritorio
            ├── MIME: Brave para web, OnlyOffice para PDF
            ├── GitHub Desktop handlers
            └── Entradas .desktop custom: VS Code (carpetas), Hydra, Affine, Hayase (AppImages)
```

## Personalización

### Agregar un paquete

```nix
# En modules/user/apps.nix, agrega el nombre dentro del bloque home.packages
brave  # ejemplo
```

### Agregar un nuevo módulo

1. Crear el archivo en `modules/system/` o `modules/user/` según corresponda
2. Importarlo en `configuration.nix` (sistema) o `home.nix` (usuario)

### Cambiar el theme de GTK

Editar `modules/user/core.nix`:

```nix
gtk.theme.name = "tu-theme";
gtk.theme.package = pkgs.tu-theme-package;
```

## Hardware

| Componente | Detalle |
|-----------|---------|
| Laptop | MSI Katana 15 B13V |
| CPU | Intel (Raptor Lake) |
| GPU | NVIDIA (RTX 4060/4070 laptop) + Intel integrada |
| RAM | 16+ GB |
| Almacenamiento | NVMe SSD |

## Notas

- La especialización `performance` en `hardware.nix` cambia NVIDIA Prime a **sync** (máximo rendimiento, mayor consumo). Se selecciona desde systemd-boot.
- Los AppImages (Hydra, Affine, Hayase) se esperan en `~/Apps/` con sus íconos en `~/Apps/icons/`.
- El fondo de pantalla de SDDM apunta a `~/Imágenes/Fondos de Pantalla/`. Cambiar la ruta si es diferente.
