# 版本更新说明

## 11.0.2

Intel macOS 预览版，继续使用 DWProton 11.0-17 的 Wine 源码。Heroic 运行时包为 `dwproton-x64-macos-11.0.2.app`，运行时列表显示发行版本 `11.0.2`。

- 修复 macOS 下同进程分层子窗口的合成和透明度，解决蓝色星原启动器内嵌界面和协议弹窗的显示问题。
- 容器更新后，如果 DirectWrite 在 Windows 字体目录找不到注册的文件，使用 Wine 登记的外部字体路径。已验证 32 位和 64 位程序可以枚举 Tahoma。
- 嵌入式子窗口传来的光标无法读取时，回退到系统箭头。
- 支持启用 `DWPROTON_WEBVIEW2_GDI=1` 的启动器合成跨进程 WebView2 窗口，并修复部分应用在 macOS Dock 初始化时遇到的问题。

在现有游戏容器的副本上，NIKKE 可通过官方启动器进入大厅，鸣潮可通过 DX11 进入开放世界。NIKKE 的标题背景视频仍有解码错误。

## 11.0-17 macOS 预览版 1

首个 Intel macOS 预览版。[发行说明](https://github.com/Husky0c/dwproton-macos/releases/tag/v11.0-17-macos.1)
