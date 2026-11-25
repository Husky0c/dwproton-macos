# DWProton macOS

DWProton macOS 是面向 Intel macOS 的 Wine 运行时，基于 DWProton 11.0-17 使用的 Wine 源码。可在 Heroic 中作为自定义运行时启动 32 位和 64 位 Windows 程序。

## 系统要求

- Intel x86_64 处理器。
- macOS 部署目标为 14.0。
- Vulkan 程序依赖 1401 NVIDIA NVK 驱动提供的 `/Library/GPUBundles/nvmtl/libvulkan.1.dylib`。[NVK 驱动文档](https://github.com/HighDelay/nvidia-macos-driver-nvk)

## 安装

1. 下载 `dwproton-x64-macos-11.0.2.tar.gz` 和 `SHA256SUMS`。[下载 11.0.2](https://github.com/Husky0c/dwproton-macos/releases/tag/v11.0.2) · [版本说明](CHANGELOG.md)
2. 在下载目录校验并解压。

   ```sh
   shasum -a 256 -c --ignore-missing SHA256SUMS &&
     tar -xzf dwproton-x64-macos-11.0.2.tar.gz
   ```

3. 将解压得到的 `dwproton-x64-macos-11.0.2.app` 放入 `~/Library/Application Support/heroic/tools/wine/`。
4. 重启 Heroic，在游戏设置的 Wine 版本中选择 **DWProton macOS x64 - 11.0.2**。

安装后可从终端检查运行时版本。

```sh
"$HOME/Library/Application Support/heroic/tools/wine/dwproton-x64-macos-11.0.2.app/Contents/Resources/wine/bin/wine" --version
```

Heroic 显示 macOS 发行版本 `11.0.2`，`wine --version` 显示上游 Wine 版本 `11.0`。

## 兼容性

验证环境为 macOS 26.7.3、Intel Core i5-12600KF 和 NVIDIA GeForce RTX 5060。主分支构建通过了 32 位和 64 位 Windows 程序的基础运行测试。Apple Silicon 和其他显卡的兼容性待验证。

NIKKE 已在开发构建中通过官方启动器进入大厅。测试时在游戏的 Wine 容器中单独配置了 DXVK。标题背景视频仍有解码错误。

使用 WebView2 的应用可设置 `DWPROTON_WEBVIEW2_GDI=1`，启用 macOS 对跨进程 WebView2 软件绘制窗口的合成。`DWPROTON_WEBVIEW2_BROWSER_ARGS` 为 WebView2 浏览器主进程追加参数。

鸣潮国服的验证配置使用关闭了 WPF 透明窗口的启动器 `3.1.0.1`，并在独立 Wine 容器中配置 WebView2 `158.0.4370.33`。将 `msedgewebview2.exe` 的兼容模式设为 Windows 10，并在启动器的环境中添加以下变量。Wine 更新容器后，应重新确认兼容模式。

```sh
export DOTNET_SYSTEM_GLOBALIZATION_USENLS=1
export WEBVIEW2_BROWSER_EXECUTABLE_FOLDER='C:\Program Files (x86)\Microsoft\EdgeCore\158.0.4370.33'
export WEBVIEW2_USER_DATA_FOLDER='C:\users\steamuser\AppData\Local\WutheringWavesWebView2'
export DWPROTON_WEBVIEW2_GDI=1
export DWPROTON_WEBVIEW2_BROWSER_ARGS='--disable-gpu --disable-gpu-compositing --disable-software-rasterizer --use-gl=disabled --in-process-gpu --disable-features=ForceSWDCompWhenDCompFallbackRequired'
```

## 从源码构建

```sh
git clone https://github.com/Husky0c/dwproton-macos.git
cd dwproton-macos
```

仓库包含完整的 Wine 源码。构建文档列出了 Intel macOS 所需的工具链、依赖和命令。[构建指南](BUILD.md)

预览版的 Release 附有对应的源码包。当前源码基于 Dawn Winery 的 Wine 提交 `a45ed99`。[DWProton](https://dawn.wine/dawn-winery/dwproton) · [上游 Wine 源码](https://dawn.wine/dawn-winery/wine-dwproton/commit/a45ed99f3b9898eaec1303458bf40d082a6565b7)

## 许可证

Wine 及本项目的移植改动采用 LGPL-2.1-or-later。随运行时分发的第三方组件保留各自的许可证。[Wine 许可证](COPYING.LIB) · [第三方组件](THIRD_PARTY.md)
