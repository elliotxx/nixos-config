{ config, pkgs, ... }:

{
  # 启用 X11 窗口系统
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
    
    # 添加输入法支持
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-chinese-addons
        fcitx5-configtool
      ];
    };
  };
} 