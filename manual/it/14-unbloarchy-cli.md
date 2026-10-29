# Unbloarchy CLI

Unbloarchy viene di solito controllato tramite i tasti di scelta rapida e il menu di Unbloarchy (`Super + Space`). Ma puoi controllarlo anche tramite la CLI `unbloarchy`. Questo è particolarmente utile quando fai lavorare un agente AI insieme a te sulla personalizzazione o sulla configurazione.

La CLI ha accesso a tutta la strumentazione interna usata sia tramite il menu sia in altro modo. Puoi vedere tutto ciò che è disponibile eseguendo `unbloarchy` nel terminale.

Ha un aspetto simile a questo:

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

E puoi approfondire ogni singolo gruppo:

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

Ogni comando accetta anche `--help`, sia che tu lo chieda a un intero gruppo (`unbloarchy capture --help`) sia a un singolo comando (`unbloarchy capture screenshot --help`).

### Aprire il menu dal terminale

Il menu di Unbloarchy è anche scriptabile, il che è comodo per le tue associazioni di tasti personalizzate. `unbloarchy menu` lo apre alla radice, e puoi saltare direttamente a qualsiasi punto dell'albero nominandolo: `unbloarchy menu summon appearance.theme` va dritto al selettore del tema, `unbloarchy menu toggle system` apre il menu di sistema e lo richiude se è già aperto, e `unbloarchy menu close` lo mette via.
