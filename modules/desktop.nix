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

  # zsh 配置
  programs.zsh = {
    enable = true;
    
    # oh-my-zsh 配置
    ohMyZsh = {
      enable = true;
      theme = "dracula";
      plugins = [
        "git"
        "zsh-autosuggestions"
        "autojump"
        "history-substring-search"
        "fzf"
        "kube-ps1"
        "kubectl"
      ];
    };

    # 语法高亮和自动建议
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;

    # 添加自定义配置
    initExtra = ''
      # fzf 配置
      export FZF_BASE=${pkgs.fzf}/bin/fzf
      export FZF_COMPLETION_TRIGGER='~~'

      # kube-ps1 配置
      PROMPT='$(kube_ps1) '$PROMPT

      # kubectl 相关别名
      alias kctx='kubeon && kubectx'
      alias kns='kubeon && kubens'
      alias k='kubectl'

      # 常用工具别名
      alias dk='docker'
      alias dkc='docker-compose'
      alias c='clear'

      # Go 环境配置
      export GOPROXY=https://goproxy.cn,direct
    '';
  };

  # 安装相关依赖包
  environment.systemPackages = with pkgs; [
    fzf
    autojump
    kubectx   # 提供 kubectx 和 kubens 命令
    kube-ps1
  ];
} 