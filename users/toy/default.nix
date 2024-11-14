{ config, pkgs, ... }: 

{
  users = {
    users.toy = {
      isNormalUser = true;
      group = "toy";
      
      # 基本信息
      description = "toy";
      home = "/home/toy";
      
      # 用户组
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
      ];
      
      # 环境配置
      shell = pkgs.fish;
      createHome = true;
    };

    # 用户组配置
    groups.toy = { };
  };
}