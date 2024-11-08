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

#### 重要命令对比

1. `nixos-rebuild switch`
- 仅重建当前系统配置
- 不会更新 channel
- 适用于修改了 configuration.nix 后应用更改

2. `nixos-rebuild switch --upgrade`
- 先执行 `nix-channel --update` 更新所有 channel
- 然后使用最新的 channel 重建系统
- 会升级所有可升级的包
- 适用于系统完整升级

3. `nix-channel --update && nixos-rebuild switch`
- 效果与 `switch --upgrade` 相同
- 分步执行可以更清楚地看到更新过程

#### 升级过程说明

当执行 `nixos-rebuild switch --upgrade` 时会发生以下步骤：

1. 更新阶段
- 更新所有配置的 channel
- 下载最新的包信息
- 检查可更新的包

2. 构建阶段
- 解析系统配置
- 下载需要的包
- 构建新的系统配置

3. 切换阶段
- 激活新构建的配置
- 重启相关服务
- 更新 boot loader 配置

4. 清理阶段
- 保留旧配置用于回滚
- 更新系统配置链接

注意事项：
- 升级可能需要较长时间，取决于更新内容的多少
- 建议在升级前确保有足够的磁盘空间
- 重要系统升级前最好先备份关键数据

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
# 备份整个配置目录
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

### 系统升级最佳实践

#### 稳定性考虑

1. Channel 选择
- `nixos-unstable`: 最新特性但可能不稳定
- `nixos-23.11` (或其他版本号): 更稳定的发行版 channel
- 生产环境建议使用稳定版 channel

2. 升级策略
```bash
# 查看当前 channel
nix-channel --list

# 切换到稳定版 channel（推荐）
sudo nix-channel --add https://nixos.org/channels/nixos-23.11 nixos
sudo nix-channel --update
```

#### 升级前准备

1. 备份重要数据
```bash
# 备份配置
sudo cp -r /etc/nixos /etc/nixos.backup

# 记录当前状态
nixos-version > current_version.txt
```

2. 检查磁盘空间
```bash
# 检查可用空间
df -h

# 必要时清理旧版本
sudo nix-collect-garbage -d
```

#### 安全升级流程

1. 先测试配置
```bash
# 更新但不切换，用于测试
sudo nixos-rebuild test --upgrade

# 如果测试成功，再执行切换
sudo nixos-rebuild switch --upgrade
```

2. 分步升级（更安全的方式）
```bash
# 1. 先更新 channel
sudo nix-channel --update

# 2. 查看更新内容
nix-env -qa --available

# 3. 构建但不激活
sudo nixos-rebuild build

# 4. 确认无误后切换
sudo nixos-rebuild switch
```

#### 问题处理机制

1. 配置出错时的回滚
```bash
# 回滚到上一个正常配置
sudo nixos-rebuild switch --rollback
```

2. 保留多个可回滚版本
```bash
# 在 configuration.nix 中设置
boot.loader.systemd-boot.configurationLimit = 10;  # 保留最近 10 个版本
```

#### 推荐的升级周期

1. 日常维护
- 小规模配置修改：随时使用 `nixos-rebuild switch`
- 包更新：每周或每月使用 `nixos-rebuild switch --upgrade`

2. 大版本升级
- 建议等待新版本发布 1-2 个月后再升级
- 先在测试环境验证
- 周末或非工作时间进行升级
- 确保有足够时间处理可能的问题

#### 升级后检查

1. 系统状态检查
```bash
# 检查系统版本
nixos-version

# 检查服务状态
systemctl --failed

# 检查日志
journalctl -b -p err
```

2. 应用程序验证
- 测试关键应用程序是否正常工作
- 检查重要服务是否正常运行
- 验证用户环境配置

#### 注意事项

1. 稳定性保障
- 不要频繁切换 channel
- 重要服务器谨慎使用 `--upgrade`
- 保持充足的回滚版本

2. 资源管理
- 定期清理旧版本释放空间
- 监控升级过程的资源使用
- 保持足够的磁盘空间余量

3. 文档记录
- 记录每次重要升级
- 记录遇到的问题和解决方案
- 维护升级检查清单

### 配置生效说明

#### 不需要重启的情况

以下更改通过 `nixos-rebuild switch` 后立即生效：
- 大多数软件包的安装/删除
- 系统服务的配置更改
- 用户配置更改
- 网络设置
- 防火墙规则
- 环境变量

```bash
# 应用配置并立即生效
sudo nixos-rebuild switch
```

#### 需要重启的情况

以下更改需要重启系统才能完全生效：
1. 内核相关
- 内核版本更新
- 内核模块更改
- 内核参数修改

2. 底层系统组件
- systemd 版本更新
- 硬件驱动更改
- 启动加载项修改

3. 特定系统设置
- 主机名更改
- 硬件配置更改
- bootloader 配置

```bash
# 对于需要重启的更改，可以先构建但延迟生效
sudo nixos-rebuild boot   # 下次重启时生效
sudo reboot              # 立即重启系统
```

#### 最佳实践

1. 分步处理更改
```bash
# 1. 先测试配置
sudo nixos-rebuild test

# 2. 如果涉及重要更改，先用 boot
sudo nixos-rebuild boot

# 3. 确认无误后重启
sudo reboot
```

2. 安全考虑
- 重要服务器的更改最好在维护窗口进行
- 保持至少一个已知正常的配置版本
- 重启前确保关键服务已正确保存状态

### NixOS 命令工作原理

#### nixos-rebuild 工作流程

1. `nixos-rebuild switch` 背后的过程：
   ```bash
   nixos-rebuild switch
   ```
   - 读取 `/etc/nixos/configuration.nix` 及其导入的所有模块
   - 解析所有配置，生成系统闭包（closure）
   - 构建新的系统配置到 `/nix/store`
   - 创建新的系统配置文件链接
   - 更新 GRUB/systemd-boot 引导配置
   - 重启受影响的系统服务
   - 更新 `/run/current-system` 符号链接

2. `nixos-rebuild test` 的区别：
   ```bash
   nixos-rebuild test
   ```
   - 执行与 switch 相同的构建过程
   - 但不更新 boot loader 配置
   - 不创建持久的系统配置链接
   - 仅临时激活新配置用于测试
   - 重启后会恢复到之前的配置

3. `nixos-rebuild boot` 的特点：
   ```bash
   nixos-rebuild boot
   ```
   - 构建新系统配置
   - 更新 boot loader 配置
   - 添加新配置到启动选项
   - 但不立即激活新配置
   - 下次重启时才会使用新配置

#### nix-channel 命令解析

1. `nix-channel --update` 过程：
   ```bash
   nix-channel --update
   ```
   - 获取配置的 channel URL
   - 下载最新的 channel 元数据
   - 更新 `/nix/var/nix/profiles/per-user/root/channels`
   - 更新 channel 的 nixpkgs 数据库
   - 生成新的 channel 二进制缓存

2. `nix-channel --list` 工作原理：
   ```bash
   nix-channel --list
   ```
   - 读取 `~/.nix-channels`（普通用户）或 `/root/.nix-channels`（root 用户）
   - 显示已配置的 channel 名称和 URL
   - 检查 channel 的本地缓存状态

#### nix-collect-garbage 详解

1. `nix-collect-garbage -d` 执行过程：
   ```bash
   nix-collect-garbage -d
   ```
   - 确定可达性（reachability）从 GC roots
   - 标记所有当前使用的路径
   - 删除未被标记的路径
   - 清理 /nix/store 中未引用的文件
   - 删除旧的系统配置
   - 更新 boot loader 配置

2. 垃圾回收的保护机制：
   - 活动配置文件被保护
   - 当前使用的包被保护
   - boot.loader.configurationLimit 控制保留配置数量
   - 通过 nix.gc.automatic 配置自动清理

#### home-manager 命令原理

1. `home-manager switch` 过程：
   ```bash
   home-manager switch
   ```
   - 读取用户的 home-manager 配置
   - 解析依赖关系
   - 构建用户环境
   - 生成配置文件（如 .zshrc）
   - 创建必要的符号链接
   - 更新用户环境变量

2. 配置生效机制：
   - 用户级配置立即生效
   - 创建/更新 ~/.config 下的配置
   - 管理 dotfiles
   - 处理软件包安装

#### 系统回滚机制

1. `nixos-rebuild switch --rollback` 工作流程：
   ```bash
   nixos-rebuild switch --rollback
   ```
   - 读取上一个系统配置的链接
   - 验证配置的完整性
   - 切换系统符号链接
   - 更新 boot loader 配置
   - 重启相关服务

2. 配置版本管理：
   - 保存在 /nix/var/nix/profiles/system-*
   - 维护配置的时间戳和版本信息
   - 通过 boot loader 提供多版本选择
   - 支持在启动时选择不同配置

#### 重要文件位置

1. 系统配置相关：
   - `/etc/nixos/` - NixOS 配置目录
   - `/nix/store/` - Nix 包存储
   - `/nix/var/nix/profiles/` - 系统配置档案
   - `/run/current-system` - 当前系统配置链接

2. 用户配置相关：
   - `~/.config/nixpkgs/` - 用户包配置
   - `~/.nix-profile/` - 用户环境配置
   - `~/.nix-channels` - 用户 channel 配置

3. 缓存和数据：
   - `/nix/var/nix/gcroots/` - GC roots
   - `/nix/var/nix/db/` - Nix 数据库
   - `/nix/var/nix/profiles/` - 配置档案