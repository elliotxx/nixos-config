{ config, pkgs, ... }:

{
  # 用户配置
  users.users.yym = {
    isNormalUser = true;
    home = "/home/yym";
    description = "yym";
    extraGroups = [ "wheel" "networkmanager" ]; # 启用 sudo 权限和网络管理权限
  };
} 