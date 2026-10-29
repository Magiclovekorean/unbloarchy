# Unbloarchy CLI

Unbloarchy обычно управляется через горячие клавиши и меню Unbloarchy (`Super + Space`). Но им также можно управлять через `unbloarchy` CLI. Это особенно полезно, когда вы работаете с AI-агентом над кастомизацией или конфигурацией.

CLI имеет доступ ко всему внутреннему инструментарию, который используется как через меню, так и иным образом. Вы можете увидеть всё, что доступно, запустив `unbloarchy` в терминале.

Выглядит это примерно так:

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

И по каждой группе можно углубиться:

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

Каждая команда тоже принимает `--help`, независимо от того, спрашиваете ли вы целую группу (`unbloarchy capture --help`) или отдельную команду (`unbloarchy capture screenshot --help`).

### Открытие меню из терминала

Меню Unbloarchy также можно вызывать из скриптов, что удобно для ваших собственных привязок клавиш. `unbloarchy menu` открывает его в корне, и вы можете перейти сразу к любому пункту дерева, назвав его: `unbloarchy menu summon appearance.theme` сразу переходит к выбору темы, `unbloarchy menu toggle system` открывает системное меню и снова закрывает его, если оно уже открыто, а `unbloarchy menu close` убирает его.
