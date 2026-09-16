# MyNixConfig

Configuración declarativa y reproducible de NixOS para **MSI Katana 15 B13V** (hostname: `Suisei`).

Repositorio personal que define el entorno de trabajo y gaming utilizando [NixOS](https://nixos.org/) + [Flakes](https://wiki.nixos.org/wiki/Flakes) + [Home-Manager](https://github.com/nix-community/home-manager) + [nh](https://github.com/viperML/nh) (Nix Helper).

---

## Características Principales

- **Doble Canal de Paquetes (Unstable + Stable)**:
  - Canal principal inestable (`nixpkgs-unstable`) para software de desarrollo, gaming y utilidades recientes.
  - Canal estable (`nixos-26.05`) expuesto mediante el overlay `pkgs.stable` en `flake.nix` para aplicaciones donde se prioriza estabilidad (ofimática, sincronización, mensajería, etc.).
- **Entorno de Escritorio**:
  - KDE Plasma 6 nativo sobre Wayland con SDDM (`services.desktopManager.plasma6`).
  - Módulo `sddm-kcm` para gestionar la pantalla de inicio directamente desde las Preferencias del Sistema de KDE.
- **Gráficos Híbridos NVIDIA Optimus**:
  - Intel Raptor Lake (iGPU) + NVIDIA RTX Serie 40 (dGPU) configuradas en modo **PRIME Offload**.
  - Script utilitario global `prime-run` (y alias `game`) para enviar la carga de juegos o aplicaciones a la GPU dedicada a demanda.
- **Optimizaciones Gaming**:
  - Steam integrado con `gamescopeSession`, GameMode, ProtonTricks y soporte Python GUI.
  - Overlay de métricas y rendimiento con **MangoHud** (HUD superior izquierdo, toggle con `Shift_R + F12`).
  - Kernel con parámetros optimizados (`preempt=full`, `nvidia_drm.modeset=1`, `intel_iommu=on`).
- **Gestión del Sistema con `nh`**:
  - Aliases de Zsh simplificados mediante `nh` (`nh os switch`, `nh clean`, `nh search`) con limpieza periódica automatizada.
- **Servicios y Automatización**:
  - Base de datos relacional local con **MariaDB**.
  - Unidad y temporizador de usuario systemd (`rclone-sync`) para respaldos automáticos cada hora hacia Google Drive (`gdrive:Mis_Respaldos/`).
  - Gestión de audio moderno con **PipeWire** (con compatibilidad de 32-bit, PulseAudio y JACK).
  - Ahorro de energía y control térmico mediante **TLP** y **Thermald**.
  - ZRAM Swap activo al 100% con compresión `zstd`.
- **Módulo de Firewall**:
  - Gestión modular de puertos en `firewall.nix` (rangos de puertos TCP/UDP 27015-27030 abiertos para Steam).

---

## Requisitos

- NixOS con soporte de Flakes habilitado:
  ```nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  ```
- Archivo `hardware-configuration.nix` correspondiente al equipo en la raíz del repositorio.
- Conexión a internet.

---

## Uso

### Reconstruir el sistema

Gracias a la integración con `nh` y los aliases configurados en Zsh, los comandos se ejecutan sin rutas largas:

```bash
# Reconstruir y aplicar cambios (alias: rebuild)
nh os switch
# o bien: rebuild

# Actualizar inputs del flake y reconstruir (alias: upgrade)
nh os switch --update
# o bien: upgrade
```

*Método tradicional alternativo con NixOS:*
```bash
sudo nixos-rebuild switch --flake /etc/nixos#Suisei
```

### Limpieza del Nix Store

```bash
# Limpiar generaciones antiguas usando nh (alias: gcclean)
nh clean all
# o bien: gcclean
```

*Método tradicional alternativo:*
```bash
sudo nix-collect-garbage -d && sudo nixos-rebuild boot --flake /etc/nixos#Suisei
```

### Búsqueda de paquetes

```bash
# Buscar paquetes en nixpkgs usando nh (alias: nxsearch)
nh search <nombre-paquete>
# o bien: nxsearch <nombre-paquete>
```

### Ejecutar aplicaciones con la GPU NVIDIA

```bash
# Usando el script del sistema
prime-run <comando>

# Usando el alias en Zsh
game <comando>

# Lanzar juegos con MangoHud + GameMode + GameScope (alias: perfgame)
perfgame <comando>
```

---

## Estructura del Repositorio

La arquitectura del repositorio está consolidada de manera limpia y directa:

```text
.
├── flake.nix                  # Entry point del flake
│   ├── inputs: nixpkgs (unstable), nixpkgs-stable (26.05), nixos-hardware, home-manager
│   ├── overlay: pkgs.stable para acceso a paquetes estables
│   └── outputs: host "Suisei" (x86_64-linux) integrando hardware y home-manager
│
├── configuration.nix          # Configuración del sistema a nivel NixOS
│   ├── Boot: systemd-boot, kernel linuxPackages_latest, parámetros preempt=full
│   ├── Hardware: NVIDIA Prime offload, aceleración VA-API, Bluetooth, PipeWire
│   ├── Escritorio: SDDM Wayland + KDE Plasma 6 + sddm-kcm
│   ├── Servicios: TLP, Thermald, Flatpak, Fstrim, MariaDB / MySQL
│   ├── Automatización: Systemd timer/service para rclone-sync con Google Drive
│   ├── Nix & nh: Cachix, optimización automática del store y configuración de nh
│   ├── Red & Localización: Hostname Suisei, es_MX.UTF-8, zona horaria, import firewall.nix
│   └── Paquetes base y fuentes (Nerd Fonts, Google Fonts, etc.)
│
├── firewall.nix               # Reglas y rangos de puertos de red (Nix Firewall Manager / Steam)
│
├── home.nix                   # Configuración del usuario zhi (Home-Manager)
│   ├── Paquetes: Selección estructurada en paquetes estables (pkgs.stable) e inestables (pkgs)
│   ├── Shell: Zsh con Oh-My-Zsh (tema kphoen), fastfetch y aliases adaptados a nh
│   ├── Gaming: Configuración personalizada de MangoHud (Shift_R+F12)
│   ├── Git: Identidad de usuario y rama principal main
│   └── XDG: Directorios de usuario estándar en español
│
└── README.md                  # Documentación del repositorio
```

---

## Personalización

### Agregar un paquete al usuario

Edita `home.nix` dentro de `home.packages`:

- **Para paquetes de la rama inestable (más recientes):**
  ```nix
  home.packages = with pkgs; [
    mi-paquete-reciente
  ];
  ```

- **Para paquetes de la rama estable (`nixos-26.05`):**
  ```nix
  home.packages = with pkgs; [
    pkgs.stable.mi-paquete-estable
  ];
  ```

### Agregar un paquete del sistema

Edita `configuration.nix` dentro de `environment.systemPackages`:
```nix
environment.systemPackages = with pkgs; [
  mi-herramienta-global
];
```

### Respaldo con Rclone

En `configuration.nix` se incluye un temporizador de systemd (`systemd.user.timers.rclone-sync`) que corre cada hora ejecutando:
```bash
rclone sync $HOME/Documentos/Sigil_Epubs gdrive:Mis_Respaldos/Epubs
rclone sync $HOME/Imágenes/Fondos gdrive:Mis_Respaldos/Fondos
```
Para que funcione, asegúrate de tener configurado un remote en rclone llamado `gdrive`:
```bash
rclone config
```

### Reglas de Firewall

Para abrir puertos o rangos adicionales para servidores o juegos, edita `firewall.nix`:
```nix
networking.firewall = {
  allowedTCPPorts = [ ... ];
  allowedUDPPorts = [ ... ];
  allowedTCPPortRanges = [
    { from = 27015; to = 27030; } # Steam
  ];
  allowedUDPPortRanges = [
    { from = 27015; to = 27030; } # Steam
  ];
};
```

---

## Especificaciones de Hardware

| Componente | Detalle |
|---|---|
| **Dispositivo** | Laptop MSI Katana 15 B13V |
| **CPU** | Intel Core (13va Gen - Raptor Lake) |
| **GPU Integrada** | Intel Iris Xe Graphics |
| **GPU Dedicada** | NVIDIA GeForce RTX Serie 40 (Laptop) |
| **Memoria RAM** | 16+ GB (ZRAM 100% zstd) |
| **Almacenamiento** | NVMe SSD |

---

## Notas

- **NVIDIA Prime Offload**: La tarjeta dedicada se mantiene en modo de bajo consumo y solo se activa cuando se invoca a través de `prime-run` o el alias `game`.
- **Especialización Performance eliminada**: La antigua especialización de Prime Sync fue removida a favor del modo offload nativo, optimizando la autonomía y temperaturas del portátil.
- **KDE Plasma 6**: La personalización visual y temas GTK/Qt se gestionan principalmente a través de la interfaz de KDE Plasma.
