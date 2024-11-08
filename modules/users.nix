{ config, pkgs, ... }:

{
  # 创建用户
  users.users.yym = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.zsh;  # 确保这里设置了默认 shell
  };
} 