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
    <home-manager/nixos>
    ./users/elliotxx
    ./modules/shell.nix
  ];

  # 启用 Flakes 特性以及配套的船新 nix 命令行工具
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # 将默认编辑器设置为 vim
  environment.variables.EDITOR = "vim";

  # 确保使用最新的 home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # root 用户配置
  home-manager.users.root = { pkgs, ... }: {
    home.stateVersion = "24.05";
    programs.home-manager.enable = true;
    
    # 导入共享的 zsh 配置
    imports = [ (import ./modules/shared.nix { inherit config pkgs; }).mkZshConfig ];
  };

  # 设置时区为上海
  time.timeZone = "Asia/Shanghai";

  # 系统状态版本
  system.stateVersion = "24.05";
}

