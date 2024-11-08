{ config, pkgs, ... }:

{
  # 启用 X11 窗口系统
  services.xserver = {
    enable = true;
    desktopManager.plasma5.enable = true;
  };

  # 显示管理器配置
  services.displayManager.sddm.enable = true;

  # 输入法配置 - 使用新的配置方式
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      fcitx5-configtool
    ];
  };
} 