{ config, pkgs, ... }: 

{
  users = {
    users.elliotxx = {
      isNormalUser = true;
      group = "elliotxx";
      
      # 基本信息
      description = "elliotxx";
      home = "/home/elliotxx";
      
      # 用户组
      # 添加到 wheel 组（sudo 权限）和 root 组
      extraGroups = [
        "wheel"
        "root"
        "networkmanager"
        "docker"
      ];
      
      # 环境配置
      shell = pkgs.zsh;
      createHome = true;
    };

    # 用户组配置
    groups.elliotxx = { };
  };
}