{ config, pkgs, ... }:

let
  # 获取 dracula 主题
  dracula-theme = pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "zsh";
    rev = "v1.2.5";  # 使用固定版本
    sha256 = "sha256-4lP4++Ewz00siVnMnjcfXhPnJndE6ANDjEWeswkmobg=";
  };
in
{
  # 系统级 zsh 配置
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      package = pkgs.oh-my-zsh;
    };
  };

  # 确保必要的包被安装
  environment.systemPackages = with pkgs; [
    zsh
    oh-my-zsh
    fzf
    autojump
    kubectx
  ];

  # 用户级配置
  home-manager.users.yym = { pkgs, ... }: {
    home = {
      stateVersion = "24.05";
      
      # 安装 dracula 主题
      file = {
        ".oh-my-zsh/custom/themes/dracula.zsh-theme" = {
          source = "${dracula-theme}/dracula.zsh-theme";
        };
        ".oh-my-zsh/custom/lib/lib" = {
          source = "${dracula-theme}/lib";
          recursive = true;
        };
      };
    };
    
    programs.zsh = {
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

      # 插件配置
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

      # 初始化配置
      initExtraFirst = ''
        # 基础环境变量
        export SHELL=${pkgs.zsh}/bin/zsh
        export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
      '';

      initExtra = ''
        # 加载 oh-my-zsh
        source $ZSH/oh-my-zsh.sh

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

  # 设置默认 shell
  users.defaultUserShell = pkgs.zsh;
} 