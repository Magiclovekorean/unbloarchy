# Unbloarchy CLI

Unbloarchy se obvykle ovládá pomocí klávesových zkratek a menu Unbloarchy (`Super + Space`). Ovládat ho ale můžete i prostřednictvím CLI `unbloarchy`. To se hodí zejména tehdy, když s vámi na úpravách nebo konfiguraci pracuje AI agent.

CLI má přístup ke všem interním nástrojům, které se používají jak přes menu, tak i jinak. Vše, co je k dispozici, uvidíte po spuštění `unbloarchy` v terminálu.

Vypadá to nějak takto:

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

A u každé skupiny můžete jít ještě hlouběji:

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

Každý příkaz přijímá i `--help`, ať už se zeptáte celé skupiny (`unbloarchy capture --help`), nebo jednoho příkazu (`unbloarchy capture screenshot --help`).

### Otevření menu z terminálu

Menu Unbloarchy lze ovládat i skriptem, což se hodí pro vaše vlastní klávesové zkratky. `unbloarchy menu` ho otevře na kořenové úrovni a pojmenováním můžete skočit rovnou na libovolné místo ve stromu: `unbloarchy menu summon appearance.theme` přejde přímo do výběru motivu, `unbloarchy menu toggle system` otevře systémové menu a zase ho zavře, pokud už je otevřené, a `unbloarchy menu close` ho schová.
