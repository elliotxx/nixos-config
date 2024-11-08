# VirtualBox 安装指南

本指南将帮助你在 VirtualBox 中安装 NixOS。

## 1. 准备工作

1. 下载 NixOS 最小安装镜像
```bash
# 访问 NixOS 下载页面
https://nixos.org/download.html
# 选择 "Minimal ISO, 64-bit Intel/AMD"
```

2. VirtualBox 设置
- 新建虚拟机
  - 类型：Linux
  - 版本：Other Linux (64-bit)
  - 内存：建议 4GB 或更多
  - 硬盘：建议 20GB 或更多
- 系统设置
  - 启用 EFI (在系统设置中勾选 "Enable EFI")
  - 处理器：建议 2 核或更多
- 显示设置
  - 显存：建议 32MB 或更多
- 网络设置
  - 网络适配器：NAT

## 2. 安装系统

1. 启动到 Live 环境
```bash
# 登录
用户名: nixos
密码: 留空
```

2. 分区
```bash
# 查看磁盘
lsblk

# 创建 GPT 分区表
sudo parted /dev/sda -- mklabel gpt

# 创建 EFI 分区
sudo parted /dev/sda -- mkpart ESP fat32 1MB 512MB
sudo parted /dev/sda -- set 1 esp on

# 创建根分区
sudo parted /dev/sda -- mkpart primary ext4 512MB 100%

# 格式化分区
sudo mkfs.fat -F 32 -n boot /dev/sda1
sudo mkfs.ext4 -L nixos /dev/sda2

# 挂载分区
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
```

3. 生成初始配置
```bash
# 生成初始配置文件
sudo nixos-generate-config --root /mnt

# 备份默认配置
sudo cp /mnt/etc/nixos/configuration.nix /mnt/etc/nixos/configuration.nix.backup
```

4. 下载本仓库配置
```bash
# 安装 Git（如果没有）
sudo nix-env -iA nixos.git

# 克隆配置
cd /mnt/etc/nixos
sudo rm configuration.nix
sudo git clone https://github.com/elliotxx/nixos-config.git .

# 保留生成的硬件配置
sudo cp /mnt/etc/nixos/configuration.nix.backup hardware-configuration.nix
```

5. 安装系统
```bash
# 安装 NixOS
sudo nixos-install

# 设置 root 密码
# 按提示输入密码

# 完成后重启
sudo reboot
```

## 3. 首次启动配置

1. 登录系统
- 使用 root 账户和设置的密码登录

2. 创建普通用户
```bash
# 设置用户密码
sudo passwd yym
```

3. 更新系统
```bash
# 更新 channel
sudo nix-channel --update

# 重建系统
sudo nixos-rebuild switch --upgrade
```

## 4. VirtualBox 优化

1. 安装增强功能
```bash
# 在 configuration.nix 中添加
virtualbox.guest.enable = true;
virtualbox.guest.x11 = true;
```

2. 共享文件夹设置
```bash
# 添加用户到 vboxsf 组
users.users.yym.extraGroups = [ "wheel" "networkmanager" "vboxsf" ];
```

3. 显示设置
```bash
# 如果需要更高分辨率，在 VirtualBox 中：
视图 -> 虚拟显示器 -> 选择更高的分辨率
```

4. 剪贴板共享
```bash
# 在 VirtualBox 中：
设备 -> 共享剪贴板 -> 双向
```

## 5. 常见问题

1. 如果无法启动到 EFI：
- 确保在 VirtualBox 设置中启用了 EFI
- 检查是否正确创建了 EFI 分区

2. 如果网络连接有问题：
```bash
# 检查网络状态
ip addr
# 重启网络管理器
sudo systemctl restart NetworkManager
```

3. 如果分辨率不正确：
- 确保已安装 VirtualBox 增强功能
- 重新加载 X11 配置：
```bash
sudo systemctl restart display-manager
```

## 6. 后续步骤

1. 系统更新
```bash
# 定期更新系统
sudo nixos-rebuild switch --upgrade
```

2. 配置备份
```bash
# 备份配置
sudo cp -r /etc/nixos /etc/nixos.backup
```

3. 系统维护
- 参考 [系统维护指南](system-maintenance.md)
- 参考 [故障排除指南](troubleshooting.md)