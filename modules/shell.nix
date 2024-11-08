{ config, pkgs, ... }:

let
  # 获取 oh-my-zsh
  oh-my-zsh = pkgs.fetchFromGitHub {
    owner = "ohmyzsh";
    repo = "ohmyzsh";
    rev = "b4f9698733d7b29cc495e649e26fd6c3a5dcfcae";  # 使用最新的稳定版本
    sha256 = "sha256-yvsNYoptmmm3BJeOdyt7zGuayYroraiiumOio9eZZ74=";
  };

  # 获取 dracula 主题
  dracula-theme = pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "zsh";
    rev = "v1.2.5";
    sha256 = "sha256-4lP4++Ewz00siVnMnjcfXhPnJndE6ANDjEWeswkmobg=";
  };
in
{
  # 系统级 zsh 配置
  programs.zsh.enable = true;

  # 确保必要的包被安装
  environment.systemPackages = with pkgs; [
    zsh
    fzf
    autojump
    kubectx
  ];

  # 用户级配置
  home-manager.users.yym = { pkgs, ... }: {
    home = {
      stateVersion = "24.05";
      
      # 安装 oh-my-zsh 和主题
      file = {
        ".oh-my-zsh" = {
          source = oh-my-zsh;
          recursive = true;
        };
        ".oh-my-zsh/custom/themes/dracula" = {
          source = dracula-theme;
          recursive = true;
        };
      };
    };
    
    programs.zsh = {
      enable = true;
      
      # 初始化配置
      initExtraFirst = ''
        # oh-my-zsh 配置
        export ZSH="$HOME/.oh-my-zsh"
        ZSH_THEME="dracula/dracula"
        
        # 启用的插件
        plugins=(
          git
          autojump
          history-substring-search
          fzf
          kubectl
        )

        # 加载 oh-my-zsh
        source $ZSH/oh-my-zsh.sh
      '';

      initExtra = ''
        # fzf 配置
        export FZF_BASE=${pkgs.fzf}/bin/fzf
        export FZF_COMPLETION_TRIGGER='~~'
      '';

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