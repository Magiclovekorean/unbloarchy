# Unbloarchy CLI

Unbloarchy este controlat de obicei prin tastele rapide și prin meniul Unbloarchy (`Super + Space`). Dar îl poți controla și prin CLI-ul `unbloarchy`. Acest lucru este deosebit de util atunci când un agent AI lucrează cu tine la personalizare sau configurare.

CLI-ul are acces la toate instrumentele interne folosite atât prin meniu, cât și în alte moduri. Poți vedea tot ce este disponibil rulând `unbloarchy` în terminal.

Arată cam așa:

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

Și poți aprofunda fiecare grup:

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

Fiecare comandă acceptă și `--help`, fie că întrebi un întreg grup (`unbloarchy capture --help`), fie o singură comandă (`unbloarchy capture screenshot --help`).

### Deschiderea meniului din terminal

Meniul Unbloarchy poate fi folosit și în scripturi, ceea ce este util pentru propriile tale combinații de taste. `unbloarchy menu` îl deschide la rădăcină, iar tu poți sări direct la orice punct din arbore numindu-l: `unbloarchy menu summon appearance.theme` te duce direct la selectorul de teme, `unbloarchy menu toggle system` deschide meniul de sistem și îl închide din nou dacă este deja deschis, iar `unbloarchy menu close` îl ascunde.
