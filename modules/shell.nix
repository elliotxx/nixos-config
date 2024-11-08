{ config, pkgs, ... }:

{
  # 确保 zsh 相关包被安装
  environment.systemPackages = with pkgs; [
    zsh
    oh-my-zsh
    fzf
    autojump
    kubectx
  ];

  # 启用 zsh
  programs.zsh.enable = true;

  # 用户级配置
  home-manager.users.yym = { pkgs, ... }: {
    home.stateVersion = "24.05";
    
    programs = {
      zsh = {
        enable = true;
        
        # oh-my-zsh 配置
        oh-my-zsh = {
          enable = true;
          theme = "dracula";
          plugins = [
            "git"
            "autojump"
            "history-substring-search"
            "fzf"
            "kubectl"
          ];
        };

        # zsh 插件
        plugins = [
          {
            name = "zsh-autosuggestions";
            src = pkgs.fetchFromGitHub {
              owner = "zsh-users";
              repo = "zsh-autosuggestions";
              rev = "v0.7.0";
              sha256 = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
            };
          }
          {
            name = "zsh-syntax-highlighting";
            src = pkgs.fetchFromGitHub {
              owner = "zsh-users";
              repo = "zsh-syntax-highlighting";
              rev = "0.7.1";
              sha256 = "sha256-gOG0NLlaJfotJfs+SUhGgLTNOnGLjoqnUp54V9aFJg8=";
            };
          }
        ];

        initExtra = ''
          # 基础配置
          export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
          source $ZSH/oh-my-zsh.sh

          # fzf 配置
          export FZF_BASE=${pkgs.fzf}/bin/fzf
          export FZF_COMPLETION_TRIGGER='~~'

          # 其他配置
          ${builtins.readFile "${pkgs.oh-my-zsh}/share/oh-my-zsh/templates/zshrc.zsh-template"}
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
          ZSH_THEME = "dracula";
        };
      };
    };

    # 确保 .zshrc 不被其他程序修改
    home.file.".zshrc".enable = false;
  };

  # 全局 shell 设置
  users.defaultUserShell = pkgs.zsh;
} 