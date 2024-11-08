{ config, pkgs, ... }:

{
  # 网络配置 - 更新为新的配置方式
  networking = {
    networkmanager.enable = true;  # 使用 NetworkManager 替代直接的 DHCP 配置
    # 移除过时的 DHCP 配置
    # useDHCP = false;
    # interfaces.enp0s3.useDHCP = true;
    
    # 添加基本防火墙配置
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 80 443 ];
    };
  };
} 