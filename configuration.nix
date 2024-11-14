# 编辑此配置文件以定义要在系统上安装的内容
# 可以在 configuration.nix(5) man 页面和 NixOS 手册中找到帮助
# (通过运行 'nixos-help' 访问)

{ config, pkgs, ... }:

{
  imports = [
    ./modules/boot.nix
    ./modules/shell.nix
    ./modules/desktop.nix
    ./modules/networking.nix
    ./modules/packages.nix
    ./modules/services.nix
  ] ++ (import ./users);

  # 启用 Flakes 特性以及配套的船新 nix 命令行工具
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # 将默认编辑器设置为 vim
  environment.variables.EDITOR = "vim";

  # 系统状态版本
  system.stateVersion = "24.05";
}

