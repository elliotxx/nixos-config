{ config, pkgs, ... }:

{
  # 允许非自由软件
  nixpkgs.config.allowUnfree = true;

  # 二进制缓存镜像源 - 更新为最新的清华源
  nix.settings.substituters = [ 
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    "https://cache.nixos.org/"
  ];

  # 系统软件包 - 更新 Python 版本
  environment.systemPackages = with pkgs; [
    wget 
    vim 
    neovim 
    git 
    htop 
    zsh
    python311
    go_1_21
    docker
  ];
} 