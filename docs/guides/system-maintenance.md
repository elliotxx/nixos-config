# 系统维护指南

## 系统更新

### 更新系统

1. 更新 channel
```bash
sudo nix-channel --update
```

2. 重建系统
```bash
sudo nixos-rebuild switch --upgrade
```

### nixos-rebuild 命令说明

nixos-rebuild 是 NixOS 中最重要的系统管理命令，用于应用系统配置更改、升级系统和切换系统版本。

常用命令：
```bash
# 测试配置（不应用）
sudo nixos-rebuild test

# 构建并切换到新配置
sudo nixos-rebuild switch

# 构建并激活新配置，但不设为默认启动
sudo nixos-rebuild boot

# 构建新配置，但不激活
sudo nixos-rebuild build

# 回滚到上一个配置
sudo nixos-rebuild switch --rollback
```

## 系统清理

### 清理旧版本

1. 删除旧的系统版本
```bash
# 删除所有旧版本
sudo nix-collect-garbage -d

# 只保留最近 14 天的版本
sudo nix-collect-garbage --delete-older-than 14d
```

2. 优化存储空间
```bash
# 优化 Nix store
sudo nix-store --optimise
```

## 配置管理

### 配置备份

建议定期备份配置文件：
```bash
# 备份整个配��目录
sudo cp -r /etc/nixos /etc/nixos.backup

# 或者使用 Git 管理配置
cd /etc/nixos
git init
git add .
git commit -m "Initial commit"
```

### 配置测试

在应用重要更改前，建议先测试配置：
```bash
# 测试配置
sudo nixos-rebuild test

# 如果出现问题，可以回滚
sudo nixos-rebuild switch --rollback
```

## 日常维护建议

1. 定期更新系统
2. 保持配置文件的备份
3. 重要更改前测试配置
4. 定期清理旧版本
5. 监控系统资源使用 