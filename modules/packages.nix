{ config, pkgs, ... }:

{
  # 配置 nix 包管理器
  nix = {
    settings = {
      # 配置二进制缓存镜像
      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://cache.nixos.org/"
      ];
      
      # 信任公钥
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      
      # 自动优化存储
      auto-optimise-store = true;
    };
    
    # 垃圾回收设置
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # 配置 registry，使用正确的属性集格式
    registry = {
      nixos.to = {
        type = "github";
        owner = "NixOS";
        repo = "nixpkgs";
        ref = "nixos-24.05";
      };
    };
  };

  # 允许非自由软件
  nixpkgs.config.allowUnfree = true;

  # 系统软件包
  environment.systemPackages = with pkgs; [
    wget 
    curl
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