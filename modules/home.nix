{ config, pkgs, ... }:

let
  shared = import ./shared.nix { inherit config pkgs; };
in
{
  # root 用户配置
  home-manager.users.root = { pkgs, ... }: {
    home.stateVersion = "24.05";
    programs.home-manager.enable = true;
    
    # 导入共享的 zsh 配置
    imports = [ (shared.mkZshConfig) ];
  };
} 