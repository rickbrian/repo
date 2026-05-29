# rickbrian repo

个人自编译 iOS 越狱插件统一 Sileo 源。

## 添加源

Sileo / Zebra 里添加：

```
https://rickbrian.github.io/repo/
```

## 当前收录

| 包 | 说明 | 上游 |
| --- | --- | --- |
| GumJS WebSocket (`com.gjws.gumjswebsocket`) | Frida GumJS 脚本 WebSocket 热重载注入 | [gumjs-ios-websocket](https://github.com/rickbrian/gumjs-ios-websocket) |
| TrollVNC | iOS 屏幕 VNC 远程控制 | [TrollVNC](https://github.com/rickbrian/TrollVNC) |

## 工作方式（聚合源）

本仓库不存放源码，只做"聚合"：

- `.github/workflows/build.yml` 在每次 push、手动触发、以及每 12 小时定时运行时：
  1. 从 [gumjs-ios-websocket gh-pages](https://rickbrian.github.io/gumjs-ios-websocket/) 拉取最新 deb；
  2. 从 [TrollVNC 的 GitHub Release](https://github.com/rickbrian/TrollVNC/releases) 拉取最新 rootless deb；
  3. 用 `dpkg-scanpackages` 生成 `Packages` / `Packages.bz2` / `Packages.gz` / `Release`；
  4. 部署到 `gh-pages` 分支，由 GitHub Pages 对外提供。

新增插件：在 CI 里加一段对应的下载步骤即可。

## 注意事项

- 仓库名 / URL 不要含下划线 `_`（Sileo 已知 bug，会导致无法下载包）。
- 上游项目各自维护自己的 deb 产出，本源只负责聚合与索引。
