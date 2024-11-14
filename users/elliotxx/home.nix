{ config, pkgs, ... }:

{
  home.username = "elliotxx"; 
  home.homeDirectory = "/home/elliotxx";

  # 通过 home.packages 安装一些常用的软件
  # 这些软件将仅在当前用户下可用，不会影响系统级别的配置
  # 建议将所有 GUI 软件，以及与 OS 关系不大的 CLI 软件，都通过 home.packages 安装
  home.packages = with pkgs;[
    neofetch
    nnn # terminal file manager

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    autojump

    # misc
    file
    which
    tree

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    btop  # replacement of htop/nmon

    # system call monitoring
    lsof # list open files
  ];

  # git 相关配置
  programs.git = {
    enable = true;
    userName = "elliotxx";
    userEmail = "951376975@qq.com";
    
    # 基础配置
    extraConfig = {
      init.defaultBranch = "main";
      color.ui = true;
      core.editor = "vim";
      core.ignorecase = false;
      pull.rebase = true;
      github.user = "elliotxx";
      safe.directory = "/etc/nixos";
    };
  };

  # zsh 相关配置
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    
    # oh-my-zsh 配置
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "autojump"
        "history-substring-search"
        "fzf"
        "kubectl"
        "docker"
        "kubectl"
      ];
      theme = "robbyrussell";
    };

    initExtra = ''
      # fzf 配置
      export FZF_BASE=${pkgs.fzf}/bin/fzf
      export FZF_COMPLETION_TRIGGER='~~'
    '';

    # 自定义别名
    shellAliases = {
      k = "kubectl";
      dk = "docker";
      dkc = "docker-compose";
      c = "clear";
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
} 