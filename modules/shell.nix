{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "kphoen";
      plugins = [
        "git"
        "sudo"
        "z"
        "history"
        "docker"
      ];
    };
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#Suisei";
      upgrade = "sudo nixos-rebuild switch --flake /etc/nixos#Suisei --upgrade";
      gcclean = "sudo nix-collect-garbage -d && sudo nixos-rebuild boot --flake /etc/nixos#Suisei";
      nxsearch = "nix search nixpkgs";
      game = "nvidia-offload";
      ll = "ls -lah --color=auto";
      la = "ls -A --color=auto";
      ".." = "cd ..";
      "..." = "cd ../..";
      gs = "git status";
      gp = "git push";
      gl = "git pull";
      temps = "watch -n 2 sensors";
      gpustat = "nvtop";
    };
    initContent = ''
      HISTSIZE=50000
      SAVEHIST=50000
      setopt HIST_IGNORE_ALL_DUPS
      setopt SHARE_HISTORY

      fastfetch
    '';
  };
}
