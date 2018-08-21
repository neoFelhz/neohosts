# 更新 Hosts 后使 Hosts 生效

## Android

如果不是使用专门的 Hosts 工具执行的 Hosts 改动，请注意文件权限为 `0644`。

Hosts 更新后，你可以通过尝试以下方式使 Hosts 生效：

- 清理掉 APP 后台
- 开关一次飞行模式
- 重启手机

## Windows

- 在 CMD （以管理员权限，如果有必要）执行：

```
ipconfig /flushdns
```

## Mac

在终端中执行：

```
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
```

## Chrome 浏览器

在完成对系统的 DNS 缓存的刷新之后，在 Chrome 浏览器访问 `chrome://net-internals/#dns` 清理 Chrome 浏览器的 DNS 缓存。
