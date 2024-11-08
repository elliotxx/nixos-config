{ config, pkgs, ... }:

{
  home-manager.users.yym = { pkgs, ... }: {
    home.stateVersion = "24.05";
    
    programs = {
      # zsh 配置
      zsh = {
        enable = true;
        
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

    # 确保创建 .zshrc
    home.file.".zshrc".text = "";
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