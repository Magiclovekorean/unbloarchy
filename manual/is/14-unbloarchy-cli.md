# Unbloarchy CLI

Unbloarchy er venjulega stjórnað með flýtilyklunum og Unbloarchy-valmyndinni (`Super + Space`). En þú getur líka stjórnað því gegnum `unbloarchy` CLI. Þetta er sérstaklega gagnlegt þegar þú ert að hafa AI agent að vinna með þér að sérstillingum eða uppsetningu.

CLI hefur aðgang að öllum innri verkfærunum sem eru notuð bæði gegnum valmyndina og annars staðar. Þú getur séð allt sem er í boði með því að keyra `unbloarchy` í terminal.

Það lítur einhvern veginn svona út:

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

Og þú getur kafað dýpra í hvern hóp:

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

Sérhver skipun tekur líka `--help`, hvort sem þú spyrð heilan hóp (`unbloarchy capture --help`) eða eina skipun (`unbloarchy capture screenshot --help`).

### Að opna valmyndina úr terminal

Það er líka hægt að stýra Unbloarchy-valmyndinni með forskriftum, sem er þægilegt fyrir þína eigin flýtilykla. `unbloarchy menu` opnar hana við rótina og þú getur hoppað beint að hvaða stað sem er í trénu með því að nefna hann: `unbloarchy menu summon appearance.theme` fer beint í þemavalið, `unbloarchy menu toggle system` opnar kerfisvalmyndina og lokar henni aftur ef hún er þegar opin og `unbloarchy menu close` leggur hana í burtu.
