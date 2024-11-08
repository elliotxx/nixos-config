{ config, pkgs, ... }:

{
  home-manager.users.yym = { pkgs, ... }: {
    programs.zsh = {
      enable = true;
      
      oh-my-zsh = {
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

      # zsh 插件配置更新为新的语法
      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-syntax-highlighting"; }
          { name = "zsh-users/zsh-autosuggestions"; }
        ];
      };

      # 初始化脚本
      initExtraFirst = ''
        # fzf 配置
        export FZF_BASE=${pkgs.fzf}/bin/fzf
        export FZF_COMPLETION_TRIGGER='~~'
      '';

      # 别名配置
      shellAliases = {
        k = "kubectl";
        dk = "docker";
        dkc = "docker-compose";
        c = "clear";
      };

      # 环境变量
      sessionVariables = {
        GOPROXY = "https://goproxy.cn,direct";
      };
    };
  };

  # 系统级别配置
  environment = {
    systemPackages = with pkgs; [
      fzf
      autojump
      kubectx
    ];
    shells = with pkgs; [ zsh ];
  };

  # 设置 zsh 为默认 shell
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
} 