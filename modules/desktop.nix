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

  # oh-my-zsh 配置 - 更新为新的配置方式
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = ["git" "python" "man" "sudo" "docker" "kubectl"];
      theme = "agnoster";
    };
    syntaxHighlighting.enable = true;  # 添加语法高亮
    autosuggestions.enable = true;     # 添加自动补全建议
  };
} 