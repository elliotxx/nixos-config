{ config, pkgs, ... }:

{
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
}