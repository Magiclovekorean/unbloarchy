# Unbloarchy CLI

Normalment, Unbloarchy es controla amb les tecles d'accés ràpid i el menú d'Unbloarchy (`Super + Space`). Però també el pots controlar amb la CLI `unbloarchy`. Això és especialment útil quan tens un agent d'IA treballant amb tu en la personalització o la configuració.

La CLI té accés a totes les eines internes que s'utilitzen tant des del menú com d'altres maneres. Pots veure tot el que hi ha disponible executant `unbloarchy` al terminal.

Té un aspecte semblant a aquest:

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

I pots aprofundir en cada grup:

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

Cada comanda també accepta `--help`, tant si preguntes per un grup sencer (`unbloarchy capture --help`) com per una sola comanda (`unbloarchy capture screenshot --help`).

### Obrir el menú des del terminal

El menú d'Unbloarchy també es pot controlar amb scripts, cosa que va molt bé per a les teves pròpies assignacions de tecles. `unbloarchy menu` l'obre a l'arrel, i pots anar directament a qualsevol punt de l'arbre anomenant-lo: `unbloarchy menu summon appearance.theme` va directe al selector de temes, `unbloarchy menu toggle system` obre el menú del sistema i el torna a tancar si ja és obert, i `unbloarchy menu close` el tanca.
