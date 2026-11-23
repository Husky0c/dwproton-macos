# DWProton macOS x64

面向 Intel macOS 的实验性 DWProton Wine 移植。当前版本基于 DWProton 11.0-17 使用的 Wine 源码，在 1401 NVIDIA 黑苹果上开发。 [DWProton](https://dawn.wine/dawn-winery/dwproton) · [Wine 源码提交](https://dawn.wine/dawn-winery/wine-dwproton/commit/a45ed99f3b9898eaec1303458bf40d082a6565b7)

Experimental Intel macOS port of the Wine component shipped with DWProton 11.0-17. Heroic runs it as a custom Wine runner.

## 安装

1. 从 [Releases](https://github.com/Husky0c/dwproton-macos/releases) 下载 `dwproton-macos-11.0-17.1-x86_64.tar.gz` 和 `SHA256SUMS`。解压后会得到 `DWProton-macOS-x64.app`。
2. 将 `.app` 放进 `~/Library/Application Support/heroic/tools/wine/`，重新打开 Heroic。
3. 在游戏设置中选择 **DWProton macOS x64 - 11.0**。首次测试可以为游戏创建独立的 Wine 容器。

命令行入口是 `DWProton-macOS-x64.app/Contents/Resources/wine/bin/wine`。运行 `wine --version` 可以检查路径和架构。

## 兼容性

- 本机原始构建的验证环境为 Intel Core i5-12600KF、RTX 5060、macOS 26.7.3 和 1401 NVIDIA Vulkan。Apple Silicon 和其他显卡尚未验证。
- Vulkan 后端使用 1401 系统里的 `/Library/GPUBundles/nvmtl/libvulkan.1.dylib`。显卡驱动需单独安装。 [1401 NVK 源码与说明](https://github.com/HighDelay/nvidia-macos-driver-nvk)
- NIKKE 在本机用官方启动器进入了大厅。该验证还使用了 NIKKE 容器里单独配置的 Heroic DXVK。标题背景视频仍有解码错误。
- 发布包只包含 Wine 运行时及其开源依赖。Heroic、DXVK、游戏文件和容器需各自准备。

## 源码

`darwin.patch` 包含 macOS 构建、窗口绘制和系统调用兼容性改动。对应 Wine 源码、依赖源码及构建步骤随 Release 提供。 [构建说明](BUILD.md) · [第三方组件](THIRD_PARTY.md)
