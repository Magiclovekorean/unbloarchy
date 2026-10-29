# Unbloarchy CLI

Unbloarchy kwa kawaida hudhibitiwa kupitia njia za mkato za kibodi na menyu ya Unbloarchy (`Super + Space`). Lakini pia unaweza kuudhibiti kupitia CLI ya `unbloarchy`. Hii ni muhimu sana unapokuwa na agent ya AI inayofanya kazi pamoja nawe kwenye ubinafsishaji au usanidi.

CLI ina ufikiaji wa zana zote za ndani zinazotumika kupitia menyu na vinginevyo. Unaweza kuona kila kinachopatikana kwa kuendesha `unbloarchy` kwenye terminal.

Inaonekana kitu kama hiki:

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

Na unaweza kuchimba zaidi katika kila kikundi:

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

Kila amri pia inakubali `--help`, iwe unauliza kikundi kizima (`unbloarchy capture --help`) au amri moja (`unbloarchy capture screenshot --help`).

### Kufungua menyu kutoka kwenye terminal

Menyu ya Unbloarchy pia inaweza kuendeshwa kwa script, jambo ambalo ni muhimu kwa keybindings zako mwenyewe. `unbloarchy menu` huifungua katika mzizi, na unaweza kuruka moja kwa moja hadi sehemu yoyote kwenye mti kwa kuitaja: `unbloarchy menu summon appearance.theme` huenda moja kwa moja hadi kichaguzi cha mandhari, `unbloarchy menu toggle system` hufungua menyu ya mfumo na kuifunga tena ikiwa tayari iko wazi, na `unbloarchy menu close` huifunga.
