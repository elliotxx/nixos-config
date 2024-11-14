{ config, pkgs, ... }:

{
  # 系统级 Git 配置
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      color.ui = true;
      core = {
        editor = "vim";
        ignorecase = false;
      };
      pull.rebase = true;
      github.user = "elliotxx";
      user = {
        name = "elliotxx";
        email = "951376975@qq.com";
      };
    };
  };
}