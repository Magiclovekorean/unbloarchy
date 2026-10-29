# Unbloarchy CLI

Unbloarchyjem se obično upravlja putem tipkovničkih prečaca i Unbloarchy izbornika (`Super + Space`). Ali njime možete upravljati i putem `unbloarchy` CLI-ja. To je osobito korisno kada AI agent radi s vama na prilagodbi ili konfiguraciji.

CLI ima pristup svim internim alatima koji se koriste i putem izbornika i na druge načine. Sve što je dostupno možete vidjeti pokretanjem naredbe `unbloarchy` u terminalu.

Izgleda otprilike ovako:

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

A možete i dublje zaroniti u svaku skupinu:

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

Svaka naredba također prihvaća `--help`, bilo da pitate cijelu skupinu (`unbloarchy capture --help`) ili jednu naredbu (`unbloarchy capture screenshot --help`).

### Otvaranje izbornika iz terminala

Unbloarchy izbornik također se može skriptirati, što je zgodno za vlastite tipkovničke prečace. `unbloarchy menu` otvara ga na korijenu, a možete skočiti izravno na bilo koju točku u stablu navodeći je: `unbloarchy menu summon appearance.theme` vodi ravno na birač tema, `unbloarchy menu toggle system` otvara izbornik sustava i ponovno ga zatvara ako je već otvoren, a `unbloarchy menu close` ga uklanja.
