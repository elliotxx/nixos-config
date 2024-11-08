{ config, pkgs, ... }:

{
  # 允许非自由软件
  nixpkgs.config.allowUnfree = true;

  # Nix 相关配置
  nix = {
    # 二进制缓存镜像源配置
    # 使用清华源加速下载，同时保留官方源作为备用
    settings.substituters = [ 
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"  # 清华源
      "https://cache.nixos.org/"                                 # 官方源
    ];

    # Channel 配置
    # 启用 channel 功能并配置稳定版和不稳定版 channel
    channel = {
      enable = true;
      channels = {
        # 稳定版 channel - 使用 24.05 版本
        nixos = {
          url = "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixos-24.05";
          priority = 10;  # 较高优先级
        };
        # 不稳定版 channel - 用于获取最新特性
        nixos-unstable = {
          url = "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixos-unstable";
          priority = 20;  # 较低优先级
        };
      };
    };
  };

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