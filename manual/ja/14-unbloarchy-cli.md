# Unbloarchy CLI

Unbloarchy は通常、ホットキーと Unbloarchy メニュー（`Super + Space`）で操作します。しかし、`unbloarchy` CLI からも操作できます。これは、AI エージェントにカスタマイズや設定を手伝ってもらうときに特に便利です。

CLI からは、メニュー経由などで使われている内部ツールのすべてにアクセスできます。利用可能なものはすべて、ターミナルで `unbloarchy` を実行すれば確認できます。

だいたいこんな感じです：

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

さらに、各グループについても詳しく見られます：

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

すべてのコマンドでも `--help` が使えます。グループ全体（`unbloarchy capture --help`）でも、個別のコマンド（`unbloarchy capture screenshot --help`）でも同様です。

### ターミナルからメニューを開く

Unbloarchy メニューはスクリプトからも操作でき、独自のキーバインドを作るときに便利です。`unbloarchy menu` でルートから開きます。名前を指定すれば、ツリー内の任意の場所へ直接移動できます：`unbloarchy menu summon appearance.theme` はテーマピッカーへ直行し、`unbloarchy menu toggle system` はシステムメニューを開き、すでに開いている場合は閉じます。`unbloarchy menu close` で閉じます。
