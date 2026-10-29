# Unbloarchy CLI

Unbloarchy paprastai valdoma sparčiaisiais klavišais ir Unbloarchy meniu (`Super + Space`). Tačiau ją taip pat galima valdyti per `unbloarchy` CLI. Tai ypač naudinga, kai kartu su jumis pritaikymo ar konfigūravimo darbus atlieka AI agentas.

CLI turi prieigą prie visų vidinių įrankių, kurie naudojami tiek per meniu, tiek kitais būdais. Viską, kas prieinama, galite pamatyti terminale paleidę `unbloarchy`.

Tai atrodo maždaug taip:

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

Ir galite gilintis į kiekvieną grupę:

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

Kiekviena komanda taip pat priima `--help`, nesvarbu, ar klausiate visos grupės (`unbloarchy capture --help`), ar vienos komandos (`unbloarchy capture screenshot --help`).

### Meniu atidarymas iš terminalo

Unbloarchy meniu taip pat galima valdyti scenarijais, o tai patogu jūsų pačių klavišų susiejimams. `unbloarchy menu` atidaro jį nuo šaknies, o jūs galite pereiti tiesiai į bet kurią medžio vietą ją įvardydami: `unbloarchy menu summon appearance.theme` nukelia tiesiai į temų pasirinkimą, `unbloarchy menu toggle system` atidaro sistemos meniu ir vėl jį uždaro, jei jis jau atidarytas, o `unbloarchy menu close` jį paslepia.
