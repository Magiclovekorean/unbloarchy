# Unbloarchy CLI

Unbloarchy styres vanligvis gjennom hurtigtastene og Unbloarchy-menyen (`Super + Space`). Men du kan også styre det gjennom `unbloarchy` CLI. Dette er særlig nyttig når du har en AI-agent som jobber sammen med deg med tilpasning eller konfigurasjon.

CLI-en har tilgang til all intern verktøystøtte som brukes både via menyen og ellers. Du kan se alt som er tilgjengelig ved å kjøre `unbloarchy` i terminalen.

Det ser omtrent slik ut:

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

Og du kan dykke dypere ned i hver gruppe:

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

Alle kommandoer tar også `--help`, enten du spør en hel gruppe (`unbloarchy capture --help`) eller en enkeltkommando (`unbloarchy capture screenshot --help`).

### Åpne menyen fra terminalen

Unbloarchy-menyen kan også skriptes, noe som er hendig for dine egne tastebindinger. `unbloarchy menu` åpner den på rotnivå, og du kan hoppe rett til ethvert punkt i treet ved å navngi det: `unbloarchy menu summon appearance.theme` går rett til temavelgeren, `unbloarchy menu toggle system` åpner systemmenyen og lukker den igjen hvis den allerede er oppe, og `unbloarchy menu close` legger den bort.
