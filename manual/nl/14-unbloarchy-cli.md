# Unbloarchy CLI

Unbloarchy wordt meestal bediend via de sneltoetsen en het Unbloarchy-menu (`Super + Space`). Maar je kunt het ook bedienen via de `unbloarchy` CLI. Dit is vooral handig wanneer je een AI-agent met je laat meewerken aan aanpassingen of configuratie.

De CLI heeft toegang tot alle interne tooling die zowel via het menu als anderszins wordt gebruikt. Je kunt alles zien wat beschikbaar is door `unbloarchy` in de terminal uit te voeren.

Het ziet er ongeveer zo uit:

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

En je kunt dieper in elke groep duiken:

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

Elke opdracht accepteert ook `--help`, of je nu een hele groep vraagt (`unbloarchy capture --help`) of een enkele opdracht (`unbloarchy capture screenshot --help`).

### Het menu openen vanuit de terminal

Het Unbloarchy-menu is ook scriptbaar, wat handig is voor je eigen toetsbindingen. `unbloarchy menu` opent het bij de root, en je kunt rechtstreeks naar elk punt in de boom springen door het te benoemen: `unbloarchy menu summon appearance.theme` gaat direct naar de themakiezer, `unbloarchy menu toggle system` opent het systeemmenu en sluit het weer als het al openstaat, en `unbloarchy menu close` bergt het weg.
