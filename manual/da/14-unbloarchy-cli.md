# Unbloarchy CLI

Unbloarchy styres normalt via genvejstasterne og Unbloarchy-menuen (`Super + Space`). Men du kan også styre det via `unbloarchy` CLI'en. Det er særligt nyttigt, når du har en AI-agent til at arbejde sammen med dig om tilpasning eller konfiguration.

CLI'en har adgang til alle de interne værktøjer, der bruges både via menuen og på anden vis. Du kan se alt, hvad der er tilgængeligt, ved at køre `unbloarchy` i terminalen.

Det ser nogenlunde sådan her ud:

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

Og du kan dykke dybere ned i hver gruppe:

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

Alle kommandoer tager også `--help`, uanset om du spørger en hel gruppe (`unbloarchy capture --help`) eller en enkelt kommando (`unbloarchy capture screenshot --help`).

### Åbning af menuen fra terminalen

Unbloarchy-menuen kan også scriptes, hvilket er praktisk til dine egne genvejstaster. `unbloarchy menu` åbner den ved roden, og du kan springe direkte til ethvert punkt i træet ved at navngive det: `unbloarchy menu summon appearance.theme` går direkte til temavælgeren, `unbloarchy menu toggle system` åbner systemmenuen og lukker den igen, hvis den allerede er fremme, og `unbloarchy menu close` gemmer den væk.
