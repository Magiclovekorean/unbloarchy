# Unbloarchy CLI

Karaniwang kinokontrol ang Unbloarchy sa pamamagitan ng mga hotkey at ng menu ng Unbloarchy (`Super + Space`). Ngunit maaari mo rin itong kontrolin sa pamamagitan ng `unbloarchy` CLI. Partikular itong nakakatulong kapag may AI agent kang katrabaho sa pag-customize o pag-configure.

May access ang CLI sa lahat ng internal tooling na ginagamit kapwa sa pamamagitan ng menu at sa iba pang paraan. Makikita mo ang lahat ng available sa pagpapatakbo ng `unbloarchy` sa terminal.

Ganito ang hitsura nito nang halos:

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

At maaari kang sumisid nang mas malalim sa bawat grupo:

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

Tumatanggap din ang bawat command ng `--help`, tanungin mo man ang buong grupo (`unbloarchy capture --help`) o isang command lang (`unbloarchy capture screenshot --help`).

### Pagbubukas ng menu mula sa terminal

Maaari ring i-script ang menu ng Unbloarchy, na madaling gamitin para sa sarili mong mga keybinding. Binubuksan ito ng `unbloarchy menu` sa root, at maaari kang dumiretso sa anumang punto sa tree sa pagbanggit nito: dumidiretso ang `unbloarchy menu summon appearance.theme` sa theme picker, binubuksan ng `unbloarchy menu toggle system` ang system menu at isinasara itong muli kung nakabukas na ito, at itinatago ito ng `unbloarchy menu close`.
