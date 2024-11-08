{ config, pkgs, ... }:

{
  # GRUB 引导加载程序配置
  boot.loader.systemd-boot.enable = true;  # 使用更现代的 systemd-boot 替代 GRUB
  boot.loader.efi.canTouchEfiVariables = true;  # 允许修改 EFI 变量
} 