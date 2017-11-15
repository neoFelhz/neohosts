# Hosts 编译

在 `_build` 目录下有三个文件

### `build.sh`

在当前目录下使用终端执行（请注意文件权限）：

```
./build.sh
```

脚本将会在 `_build` 目录下新建 `tmp/basic` `tmp/extra` 两个目录，并分别把 `hosts` 分别输出。

### `head.txt`

Hosts 头部的版权信息

### `deploy.sh`

用于将 Basic Hosts 和 Extra Hosts 部署到 Repo 的 `gh-pages` 分支，需要在环境变量中添加有关变量。

----

### Travis 编译

neoHosts 使用 Travis CI 持续集成，build on every commit in data branch.
