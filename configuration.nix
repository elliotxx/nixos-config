# 编辑此配置文件以定义要在系统上安装的内容
# 可以在 configuration.nix(5) man 页面和 NixOS 手册中找到帮助
# (通过运行 'nixos-help' 访问)

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/boot.nix
    ./modules/desktop.nix
    ./modules/networking.nix
    ./modules/packages.nix
    ./modules/services.nix
    ./modules/users.nix
  ];

  # 系统状态版本
  system.stateVersion = "24.05";
}

