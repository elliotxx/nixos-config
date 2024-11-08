{ config, pkgs, ... }:

{
  # 启用 OpenSSH 守护进程
  services.openssh.enable = true;
} 