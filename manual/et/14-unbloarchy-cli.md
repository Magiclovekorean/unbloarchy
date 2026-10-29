# Unbloarchy CLI

Unbloarchyt juhitakse tavaliselt kiirklahvide ja Unbloarchy menüü (`Super + Space`) kaudu. Aga seda saab juhtida ka `unbloarchy` CLI kaudu. See on eriti abiks siis, kui lased mõnel AI agendil endaga koos kohandusi või seadistusi teha.

CLI-l on juurdepääs kõigile sisemistele tööriistadele, mida kasutatakse nii menüü kaudu kui ka muul viisil. Kõike saadaolevat näed, kui käivitad terminalis käsu `unbloarchy`.

See näeb välja umbes selline:

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

Ja iga rühma puhul saad minna sügavamale:

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

Iga käsk võtab ka lippu `--help`, olenemata sellest, kas küsid tervet rühma (`unbloarchy capture --help`) või üht käsku (`unbloarchy capture screenshot --help`).

### Menüü avamine terminalist

Unbloarchy menüü on samuti skriptitav, mis on käepärane oma kiirklahvide jaoks. `unbloarchy menu` avab selle juurtasemel ja sa saad hüpata otse puu suvalisse kohta, kui selle nimega nimetad: `unbloarchy menu summon appearance.theme` viib otse teemavalijasse, `unbloarchy menu toggle system` avab süsteemimenüü ja sulgeb selle uuesti, kui see on juba üleval, ning `unbloarchy menu close` paneb selle ära.
