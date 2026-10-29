# Unbloarchy CLI

Unbloarchy sa zvyčajne ovláda pomocou klávesových skratiek a ponuky Unbloarchy (`Super + Space`). Môžete ho však ovládať aj cez `unbloarchy` CLI. To je obzvlášť užitočné, keď s vami na prispôsobení alebo konfigurácii spolupracuje AI agent.

CLI má prístup ku všetkým interným nástrojom, ktoré sa používajú cez ponuku aj inak. Všetko, čo je k dispozícii, si môžete pozrieť spustením príkazu `unbloarchy` v termináli.

Vyzerá to približne takto:

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

A do každej skupiny sa môžete ponoriť hlbšie:

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

Každý príkaz podporuje aj `--help`, či už sa pýtate na celú skupinu (`unbloarchy capture --help`) alebo na jeden príkaz (`unbloarchy capture screenshot --help`).

### Otvorenie ponuky z terminálu

Ponuka Unbloarchy sa dá ovládať aj skriptami, čo sa hodí pre vaše vlastné klávesové skratky. Príkaz `unbloarchy menu` ju otvorí v koreňovom zobrazení a pomenovaním môžete prejsť rovno na ľubovoľné miesto v strome: `unbloarchy menu summon appearance.theme` prejde priamo do výberu témy, `unbloarchy menu toggle system` otvorí systémovú ponuku a znova ju zatvorí, ak už je otvorená, a `unbloarchy menu close` ju skryje.
