# Unbloarchy CLI

Unbloarchyä käytetään yleensä pikanäppäimillä ja Unbloarchy-valikolla (`Super + Space`). Mutta voit hallita sitä myös `unbloarchy` CLI:n kautta. Tämä on erityisen hyödyllistä, kun työskentelet tekoälyagentin kanssa mukautusten tai määritysten parissa.

CLI:llä on pääsy kaikkiin sisäisiin työkaluihin, joita käytetään sekä valikon kautta että muuten. Näet kaiken saatavilla olevan ajamalla `unbloarchy` terminaalissa.

Se näyttää suunnilleen tältä:

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

Ja jokaiseen ryhmään voi sukeltaa syvemmälle:

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

Jokainen komento hyväksyy myös `--help`-vivun, kysyitpä sitä koko ryhmältä (`unbloarchy capture --help`) tai yksittäiseltä komennolta (`unbloarchy capture screenshot --help`).

### Valikon avaaminen terminaalista

Unbloarchy-valikko on myös skriptattavissa, mikä on kätevää omia näppäinsidoksiasi varten. `unbloarchy menu` avaa sen juuresta, ja voit hypätä suoraan mihin tahansa kohtaan puussa nimeämällä sen: `unbloarchy menu summon appearance.theme` menee suoraan teeman valitsimeen, `unbloarchy menu toggle system` avaa järjestelmävalikon ja sulkee sen uudelleen, jos se on jo auki, ja `unbloarchy menu close` sulkee sen.
