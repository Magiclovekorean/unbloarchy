# Unbloarchy CLI

Unbloarchy зазвичай керують за допомогою гарячих клавіш і меню Unbloarchy (`Super + Space`). Але керувати нею можна також через CLI `unbloarchy`. Це особливо корисно, коли агент ШІ працює з вами над кастомізацією чи конфігурацією.

CLI має доступ до всіх внутрішніх інструментів, які використовуються як через меню, так і в інший спосіб. Ви можете побачити все доступне, запустивши `unbloarchy` у терміналі.

Виглядає це приблизно так:

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

І ви можете заглибитися в кожну групу:

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

Кожна команда також приймає `--help`, незалежно від того, чи запитуєте ви цілу групу (`unbloarchy capture --help`), чи окрему команду (`unbloarchy capture screenshot --help`).

### Відкриття меню з термінала

Меню Unbloarchy також можна скриптувати, що зручно для ваших власних прив'язок клавіш. `unbloarchy menu` відкриває його в корені, і ви можете переходити прямо до будь-якої точки дерева, назвавши її: `unbloarchy menu summon appearance.theme` веде прямо до вибору теми, `unbloarchy menu toggle system` відкриває системне меню і знову закриває його, якщо воно вже відкрите, а `unbloarchy menu close` прибирає його.
