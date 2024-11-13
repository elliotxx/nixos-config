{ config, pkgs, ... }:

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

  # 设置所有用户的默认 shell
#   users.defaultUserShell = pkgs.zsh;
#   users.users.root.shell = pkgs.zsh;
} 