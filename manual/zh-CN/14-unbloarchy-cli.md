# Unbloarchy CLI

Unbloarchy 通常通过热键和 Unbloarchy 菜单（`Super + Space`）来控制。但你也可以通过 `unbloarchy` CLI 来控制它。当你让一个 AI agent 陪你一起做定制或配置时，这一点特别有用。

该 CLI 可以访问菜单以及其他地方所用的全部内部工具。你可以在终端里运行 `unbloarchy`，查看所有可用内容。

它看起来大致如下：

```
~ ❯ unbloarchy
Unbloarchy command center

Usage:
  unbloarchy <command> [args...]
  unbloarchy commands [--all] [--json] [--check]
  unbloarchy <group> --help
  unbloarchy <group> <command> --help

Common commands:
  unbloarchy update              Update Unbloarchy and system packages
  unbloarchy theme list          List available themes
  unbloarchy theme set <name>    Apply a theme
  unbloarchy font list           List available fonts
  unbloarchy screenshot          Take a screenshot
  unbloarchy debug               Print debugging information

Groups:
  agent          AI coding agents, their usage, and subscription accounts
  audio          Audio input and output controls
  bar            Unbloarchy shell bar layout and settings
  battery        Battery status helpers
  bluetooth      Bluetooth device controls
  branch         Unbloarchy git branch management
  branding       About and screensaver branding
  brightness     Display and keyboard brightness
  capture        Screenshots and screen recording
  channel        Unbloarchy release channel management
  clipboard      Clipboard helpers
  cmd            Command and shortcut helpers
  config         System configuration helpers
  debug          Diagnostics and support logs
  ...
```

你还可以深入查看每个分组：

```
~ ❯ unbloarchy capture
Capture commands — Screenshots and screen recording:
  unbloarchy capture qr                                                                                                                                                                                                       Decode a QR code from a screenshot region
  unbloarchy capture screenrecording [--fullscreen] [--with-desktop-audio] [--with-microphone-audio] [--with-webcam] [--webcam-device=<device>] [--webcam-size=<small|medium|large>] [--resolution=<size>] [--stop-recording]  Start or stop screen recording
  unbloarchy capture screenrecording with webcam                                                                                                                                                                              Pick a webcam and start a screen recording with it
  unbloarchy capture screenshot [smart|region|windows|fullscreen|scroll] [copy|save]                                                                                                                                          Take a screenshot
  unbloarchy capture text                                                                                                                                                                                                     Extract text from a screenshot region with OCR
  unbloarchy capture webcam resize <smaller|larger|reset|small|medium|large>                                                                                                                                                  Resize the active webcam recording overlay
```

每个命令也都支持 `--help`，无论你询问的是整个分组（`unbloarchy capture --help`），还是单个命令（`unbloarchy capture screenshot --help`）。

### 从终端打开菜单

Unbloarchy 菜单同样可以脚本化，这对你自己的键位绑定很方便。`unbloarchy menu` 会在根层级打开它，你也可以直接跳到树中的任意位置，只要点名即可：`unbloarchy menu summon appearance.theme` 会直接进入主题选择器，`unbloarchy menu toggle system` 会打开系统菜单，如果它已经打开则再次将其关闭，而 `unbloarchy menu close` 会把它收起来。
