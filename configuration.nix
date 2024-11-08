# 编辑此配置文件以定义要在系统上安装的内容
# 可以在 configuration.nix(5) man 页面和 NixOS 手册中找到帮助
# (通过运行 'nixos-help' 访问)

{ config, pkgs, ... }:

{
  imports = [
    # 确保 home-manager 在其他模块之后导入
    ./hardware-configuration.nix
    ./modules/boot.nix
    ./modules/desktop.nix
    ./modules/networking.nix
    ./modules/packages.nix
    ./modules/services.nix
    ./modules/users.nix
    ./modules/shell.nix
    <home-manager/nixos>
  ];

  # 确保使用最新的 home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # 设置时区为上海
  time.timeZone = "Asia/Shanghai";

  # 系统状态版本
  system.stateVersion = "24.05";
}

