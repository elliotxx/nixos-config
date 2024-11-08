{ config, pkgs, ... }:

{
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
        "kubectl"
      ];
    };

    # 语法高亮和自动建议
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;

    # 添加自定义配置
    interactiveShellInit = ''
      # fzf 配置
      export FZF_BASE=${pkgs.fzf}/bin/fzf
      export FZF_COMPLETION_TRIGGER='~~'

      # kubectl 相关别名
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
  ];
} 