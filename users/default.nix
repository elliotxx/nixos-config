# 自动导入当前目录下所有的 .nix 文件
builtins.attrValues (
  builtins.mapAttrs
    (name: _: ./. + "/${name}")
    (builtins.removeAttrs (builtins.readDir ./.) ["default.nix"])
) 