# Unbloarchy CLI

Az Unbloarchyt általában a gyorsbillentyűkkel és az Unbloarchy menüvel (`Super + Space`) vezérled. De az `unbloarchy` CLI-n keresztül is vezérelheted. Ez különösen hasznos, amikor egy AI-ügynök dolgozik veled a testreszabáson vagy a konfiguráláson.

A CLI hozzáfér minden belső eszközhöz, amelyet a menün keresztül és más módokon is használ a rendszer. Minden elérhető lehetőséget megnézhetsz, ha futtatod az `unbloarchy` parancsot a terminálban.

Valahogy így néz ki:

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

És minden csoportban mélyebbre is áshatsz:

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

Minden parancs elfogadja a `--help` kapcsolót is, akár egy egész csoportról kérdezel (`unbloarchy capture --help`), akár egyetlen parancsról (`unbloarchy capture screenshot --help`).

### A menü megnyitása a terminálból

Az Unbloarchy menü is szkriptelhető, ami jól jön a saját billentyűparancsaidhoz. Az `unbloarchy menu` a gyökérnél nyitja meg, és a fa bármely pontjára közvetlenül odaugorhatsz, ha megnevezed: az `unbloarchy menu summon appearance.theme` egyenesen a témaválasztóhoz visz, az `unbloarchy menu toggle system` megnyitja a rendszermenüt, és újra bezárja, ha már nyitva van, az `unbloarchy menu close` pedig eltünteti.
