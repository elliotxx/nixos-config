# NixOS 配置

这是一个模块化的 NixOS 配置仓库，通过将配置分割成多个功能模块来提高可维护性。

## 目录结构

```
.
├── configuration.nix          # 主配置文件
├── hardware-configuration.nix # 硬件配置文件
├── README.md                 # 本文档
└── modules/                  # 模块目录
    ├── boot.nix             # 引导加载程序配置
    ├── desktop.nix          # 桌面环境配置
    ├── networking.nix       # 网络配置
    ├── packages.nix         # 系统软件包配置
    ├── services.nix         # 系统服务配置
    ├── shell.nix           # Shell 环境配置
    └── users.nix            # 用户配置
```

## 模块说明

### boot.nix
- systemd-boot 引导加载程序（替代传统的 GRUB）
- EFI 变量支持

### desktop.nix
- KDE Plasma 5 桌面环境
- SDDM 显示管理器
- Fcitx5 中文输入法支持
  - 中文输入
  - 配置工具

### shell.nix
- Zsh 配置
- Oh-My-Zsh 设置
  - dracula 主题
  - 实用插件（git, fzf, kubectl 等）
  - 语法高亮
  - 命令自动补全
- 开发工具集成
  - FZF 模糊查找
  - Autojump 快速目录跳转
  - Kubernetes 工具
  - Docker 快捷命令
  - Go 开发环境

### networking.nix
- NetworkManager 网络管理
- 防火墙配置
  - SSH (22)
  - HTTP (80)
  - HTTPS (443)

### packages.nix
- 非自由软件支持
- 清华大学镜像源
- 基础工具
  - Vim/Neovim
  - Git
  - Python 3.11
  - Go 1.21
  - Docker

### services.nix
- OpenSSH 服务

### users.nix
- 用户账户配置
- 权限管理
  - sudo（wheel 组）
  - 网络管理

## 使用指南

### 初次使用

#### 重要提示
在使用此配置之前，请确保有正确的 hardware-configuration.nix 文件，这个文件包含了您系统的硬件配置信息。

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

#### 方案二：先安装 git

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

### 个性化配置

#### 1. 基础配置修改

- 修改用户信息 (`modules/users.nix`)：
```nix
users.users.your-username = {
  isNormalUser = true;
  home = "/home/your-username";
  description = "Your Name";
  extraGroups = [ "wheel" "networkmanager" ];
};
```

- 调整时区和语言 (`configuration.nix` 中添加)：
```nix
time.timeZone = "Asia/Shanghai";
i18n.defaultLocale = "zh_CN.UTF-8";
```

#### 2. 软件包管理

- 添加常用软件 (`modules/packages.nix`)：
```nix
environment.systemPackages = with pkgs; [
  # 你的常用软件
  firefox
  vscode
  # ...
];
```

### 应用配置

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

### 日常维护

#### 更新系统

1. 更新 channel：
```bash
sudo nix-channel --update
```

2. 重建系统：
```bash
sudo nixos-rebuild switch --upgrade
```

#### 清理系统

1. 清理旧的系统版本：
```bash
sudo nix-collect-garbage -d
```

2. 优化存储：
```bash
sudo nix-store --optimise
```

## 故障排除

1. 如果无法启动：
   - 在 GRUB 菜单选择旧版本配置启动
   - 修复配置后重新构建

2. 检查配置语法：
```bash
nix-instantiate --parse /etc/nixos/configuration.nix
```

3. 查看详细日志：
```bash
journalctl -xb
```

## 提示

1. 建议将配置文件纳入版本控制
2. 定期备份 `/etc/nixos` 目录
3. 重要更改前先使用 `nixos-rebuild test`
4. 保持 `hardware-configuration.nix` 文件不变

## 常见问题

1. 如果遇到权限问题：
   - 确保用户在 wheel 组中
   - 使用 `sudo` 执行命令

2. 如果软件包找不到：
   - 检查 channel 是否最新
   - 确认包名是否正确
   - 检查是否需要启用 unfree 支持

3. 输入法问题：
   - 确保环境变量正确设置
   - 重新登录或重启系统生效

## 贡献

欢迎提交 Pull Requests 来改进配置。请确保：
1. 遵循现有的模块化结构
2. 添加适当的中文注释
3. 测试配置可以正常工作

## 许可

MIT License
