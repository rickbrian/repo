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

## 工作方式（自包含源 + 上游 push）

本仓库**自包含**：所有 `.deb` 直接用 git 存放在 `debs/` 目录，源稳定、不依赖 artifact 过期。

- `.github/workflows/build.yml` 在 `debs/` 有变动 / 手动触发时：
  1. 用 `dpkg-scanpackages` 生成 `Packages` / `Packages.bz2` / `Packages.gz` / `Release`；
  2. 动态生成首页 `index.html`（列出全部包）；
  3. 部署到 `gh-pages` 分支，由 GitHub Pages 对外提供。

### 更新 deb 的两种方式

- **手动**：把新版 deb 丢进 `debs/`，删掉旧版，`git push` 即可。
- **自动（push 模式）**：上游项目（TrollVNC / gumjs）的 CI 编译完成后，用一个有本仓库写权限的 PAT，把对应 deb 提交到本仓库 `debs/`，自动触发重新发布。
  - TrollVNC 取 `packages-rootless` artifact 里的 deb（rootless 越狱专用）。

## 注意事项

- 仓库名 / URL 不要含下划线 `_`（Sileo 已知 bug，会导致无法下载包）。
- 上游项目各自维护自己的 deb 产出，本源只负责聚合与索引。
