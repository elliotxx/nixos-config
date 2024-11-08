{ config, pkgs, ... }:

let
  shared = import ../../modules/shared.nix { inherit config pkgs; };
in
{
  # 用户级配置
  home-manager.users.elliotxx = { pkgs, ... }: {
    # 启用 home-manager 管理
    programs.home-manager.enable = true;

    # 基础配置
    home = {
      username = "elliotxx";
      homeDirectory = "/home/elliotxx";
      stateVersion = "24.05";
    };

    # git 配置
    programs.git = {
      enable = true;
      userName = "elliotxx";
      userEmail = "951376975@qq.com";
    };

    # 导入共享的 zsh 配置
    imports = [ (shared.mkZshConfig) ];
  };
} 