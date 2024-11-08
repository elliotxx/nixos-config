# 故障排除指南

## 常见问题

### 1. 引导问题

如果系统无法启动：
- 在 GRUB/systemd-boot 菜单选择旧版本配置
- 使用 `nixos-rebuild switch --rollback` 回滚到上一个正常配置

### 2. 包管理问题

1. 找不到包：
```bash
# 更新 channel
sudo nix-channel --update

# 检查包名
nix-env -qaP | grep package-name
```

2. 下载失败：
```bash
# 检查网络连接
ping cache.nixos.org

# 尝试使用镜像
sudo nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixos-unstable nixos
sudo nix-channel --update
```

### 3. 系统配置问题

1. 配置语法错误：
```bash
# 检查配置语法
nix-instantiate --parse /etc/nixos/configuration.nix
```

2. 模块导入错误：
- 检查文件路径是否正确
- 确保模块文件存在
- 验证模块语法

### 4. 桌面环境问题

1. 显示管理器无法启动：
```bash
# 检查日志
journalctl -xb

# 重启显示管理器
sudo systemctl restart display-manager
```

2. 输入法问题：
```bash
# 检查环境变量
echo $GTK_IM_MODULE
echo $QT_IM_MODULE
echo $XMODIFIERS

# 重启输入法
fcitx5 -r
```

### 5. 网络问题

1. NetworkManager 问题：
```bash
# 检查服务状态
systemctl status NetworkManager

# 重启服务
sudo systemctl restart NetworkManager
```

2. 防火墙问题：
```bash
# 检查防火墙状态
sudo nix-shell -p iptables --run "iptables -L"
```

## 日志查看

### 系统日志

```bash
# 查看系统日志
journalctl -xb

# 查看特定服务的日志
journalctl -u service-name

# 查看实时日志
journalctl -f
```

### 配置调试

```bash
# 显示详细的错误信息
nixos-rebuild switch --show-trace

# 调试特定模块
nixos-rebuild switch -I nixos-config=/etc/nixos/modules/problematic-module.nix
```

## 恢复步骤

1. 配置出错时的恢复：
```bash
# 回滚到上一个配置
sudo nixos-rebuild switch --rollback

# 或者使用特定版本
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
sudo nixos-rebuild switch --rollback --to-generation <number>
```

2. 系统无法启动时的恢复：
- 使用安装介质启动
- 挂载系统分区
- 使用 chroot 进行修复

## 获取帮助

1. 查看文档：
```bash
# 查看 NixOS 手册
nixos-help

# 查看特定选项的文档
man configuration.nix
```

2. 在线资源：
- [NixOS 官方论坛](https://discourse.nixos.org/)
- [NixOS Wiki](https://nixos.wiki/)
- [GitHub Issues](https://github.com/NixOS/nixpkgs/issues) 