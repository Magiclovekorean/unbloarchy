# Unbloarchy CLI

Unbloarchy обикновено се управлява чрез клавишните комбинации и менюто на Unbloarchy (`Super + Space`). Но можете да го управлявате и чрез `unbloarchy` CLI. Това е особено полезно, когато AI агент работи с вас по персонализиране или конфигуриране.

CLI има достъп до всички вътрешни инструменти, които се използват както чрез менюто, така и по друг начин. Можете да видите всичко налично, като изпълните `unbloarchy` в терминала.

Изглежда приблизително така:

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

И можете да навлезете по-дълбоко във всяка група:

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

Всяка команда приема и `--help`, независимо дали питате цяла група (`unbloarchy capture --help`) или отделна команда (`unbloarchy capture screenshot --help`).

### Отваряне на менюто от терминала

Менюто на Unbloarchy също може да се скриптира, което е удобно за вашите собствени клавишни комбинации. `unbloarchy menu` го отваря в основата, а можете да прескочите директно до всяка точка от дървото, като я назовете: `unbloarchy menu summon appearance.theme` отива директно до избора на тема, `unbloarchy menu toggle system` отваря системното меню и го затваря отново, ако вече е отворено, а `unbloarchy menu close` го прибира.
