{ config, pkgs, ... }:

{
  imports = [
    ./home.nix
  ];

  # 创建用户
  users.users.elliotxx = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.zsh;
  };
} 