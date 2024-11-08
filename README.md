# NixOS 配置

这是一个模块化的 NixOS 配置仓库，通过将配置分割成多个功能模块来提高可维护性。

## 文档

- [VirtualBox 安装指南](docs/guides/virtualbox-installation.md)
- [系统维护指南](docs/guides/system-maintenance.md)
- [故障排除指南](docs/guides/troubleshooting.md)

## 目录结构

```
.
├── configuration.nix          # 主配置文件
├── hardware-configuration.nix # 硬件配置文件
├── README.md                 # 本文档
├── docs/                     # 详细文档
│   └── guides/              # 使用指南
├── modules/                  # 模块目录
│   ├── boot.nix             # 引导加载程序配置
│   ├── desktop.nix          # 桌面环境配置
│   ├── networking.nix       # 网络配置
│   ├── packages.nix         # 系统软件包配置
│   ├── services.nix         # 系统服务配置
│   ├── shared.nix           # 共享配置（如 zsh 配置）
│   └── shell.nix           # Shell 环境配置
└── users/                    # 用户配置目录
    └── elliotxx/            # 个人用户配置
        ├── default.nix      # 用户创建和权限配置
        └── home.nix         # home-manager 配置
```

## 模块说明

### 系统模块

#### boot.nix
- systemd-boot 引导加载程序
- EFI 变量支持

#### desktop.nix
- KDE Plasma 5 桌面环境
- SDDM 显示管理器
- Fcitx5 中文输入法支持

#### networking.nix
- NetworkManager 网络管理
- 防火墙配置（SSH/HTTP/HTTPS）

#### packages.nix
- 非自由软件支持
- 清华大学镜像源
- 开发工具（Git/Python/Go/Docker）

#### services.nix
- OpenSSH 服务配置

### Shell 相关

#### shared.nix
- 共享的 Zsh 配置函数 (mkZshConfig)
- Oh-My-Zsh 主题（dracula）
- Shell 插件和工具配置

#### shell.nix
- 系统级 Zsh 配置
- 必要包的安装（zsh/fzf/autojump）
- 默认 Shell 设置

### 用户配置

用户配置位于 `users/` 目录下，每个用户有独立的配置目录：

#### elliotxx/
- `default.nix`: 用户创建和权限配置
- `home.nix`: home-manager 配置
  - Git 配置
  - Zsh 用户配置（使用 shared.nix 中的 mkZshConfig）

## 快速开始

> 重要提示
> 在使用此配置之前，请确保有正确的 hardware-configuration.nix 文件，这个文件包含了您系统的硬件配置信息。

### 方案一：不安装 git

1. 备份当前系统配置：
```bash
sudo cp -r /etc/nixos /etc/nixos.backup
```

2. 下载配置文件：
```bash
cd /etc/nixos
# 下载仓库压缩包
curl -f -L -# https://github.com/elliotxx/nixos-config/archive/refs/heads/main.zip -o main.zip
# 解压文件
unzip main.zip
# 移动文件到当前目录
cp -r nixos-config-main/* .
cp -r nixos-config-main/.* . 2>/dev/null || true
# 清理临时文件
rm -rf nixos-config-main main.zip
```

3. 处理硬件配置文件：

方案一：从备份恢复（如果有备份）：
```bash
cp /etc/nixos.backup/hardware-configuration.nix .
```

方案二：重新生成（如果没有备份）：
```bash
# 生成新的硬件配置
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
```

### 方案二：先安装 git

1. 安装 git：
```bash
sudo nix-env -iA nixos.git
```

2. 然后按照常规步骤操作：
```bash
cd /etc/nixos
sudo cp -r /etc/nixos /etc/nixos.backup
git clone https://github.com/elliotxx/nixos-config.git .
```

## 个性化配置

### 1. 创建新用户

1. 在 users/ 目录下创建新用户目录：
```bash
mkdir -p users/your-username
```

2. 创建用户基本配置 (`users/your-username/default.nix`)：
```nix
{ config, pkgs, ... }:

{
  # 创建用户
  users.users.your-username = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];  # 根据需要调整权限组
    shell = pkgs.zsh;
  };
}
```

3. 创建用户 home-manager 配置 (`users/your-username/home.nix`)：
```nix
{ config, pkgs, ... }:

let
  shared = import ../../modules/shared.nix { inherit config pkgs; };
in
{
  home-manager.users.your-username = { pkgs, ... }: {
    # 启用 home-manager
    programs.home-manager.enable = true;

    # 基础配置
    home = {
      username = "your-username";
      homeDirectory = "/home/your-username";
      stateVersion = "24.05";  # 使用当前系统版本
    };

    # Git 配置
    programs.git = {
      enable = true;
      userName = "Your Name";
      userEmail = "your.email@example.com";
    };

    # 导入共享的 zsh 配置
    imports = [ (shared.mkZshConfig) ];
  };
}
```

4. 在 configuration.nix 中导入新用户配置：
```nix
{
  imports = [
    # ... 其他导入
    ./users/your-username  # 添加这一行
  ];
}
```

### 2. 调整系统设置

- 修改时区和语言 (`configuration.nix`)：
```nix
{
  # 时区设置
  time.timeZone = "Asia/Shanghai";

  # 语言设置
  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  };
}
```

### 3. 添加软件包

- 在 `modules/packages.nix` 中添加系统级软件包：
```nix
environment.systemPackages = with pkgs; [
  # 开发工具
  git
  vim
  vscode
  
  # 浏览器
  firefox
  google-chrome
  
  # 其他工具
  wget
  curl
];
```

- 在用户的 home.nix 中添加用户级软件包：
```nix
home.packages = with pkgs; [
  # 开发工具
  nodejs
  yarn
  
  # 通讯工具
  telegram-desktop
  discord
];
```

## 应用配置

1. 测试新配置：
```bash
sudo nixos-rebuild test
```

2. 如果一切正常，应用配置：
```bash
sudo nixos-rebuild switch
```

3. 如果出现问题，回滚到上一个配置：
```bash
sudo nixos-rebuild switch --rollback
```
## 贡献

欢迎提交 Pull Requests 来改进配置。请确保：
1. 遵循现有的模块化结构
2. 添加适当的注释
3. 测试配置可以正常工作

## 许可

MIT License
