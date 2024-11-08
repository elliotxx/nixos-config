{ config, pkgs, ... }:

{
  imports = [
    ./home.nix
  ];

  # 创建用户
  users.users.yym = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.zsh;
  };
} 