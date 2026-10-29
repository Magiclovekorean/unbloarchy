# Unbloarchy CLI

Unbloarchy parasti kontrolē ar karstajiem taustiņiem un Unbloarchy izvēlni (`Super + Space`). Bet to var kontrolēt arī ar `unbloarchy` CLI. Tas ir īpaši noderīgi, kad kopā ar tevi pie pielāgošanas vai konfigurēšanas strādā AI aģents.

CLI ir piekļuve visiem iekšējiem rīkiem, kas tiek izmantoti gan caur izvēlni, gan citādi. Visu pieejamo vari apskatīt, terminālī palaižot `unbloarchy`.

Tas izskatās apmēram šādi:

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

Un vari iedziļināties katrā grupā:

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

Katrai komandai ir arī `--help`, neatkarīgi no tā, vai jautā veselai grupai (`unbloarchy capture --help`) vai vienai komandai (`unbloarchy capture screenshot --help`).

### Izvēlnes atvēršana no termināļa

Unbloarchy izvēlne ir arī skriptējama, kas noder tavām paša taustiņu kombinācijām. `unbloarchy menu` to atver saknē, un vari pāriet tieši uz jebkuru vietu kokā, to nosaucot: `unbloarchy menu summon appearance.theme` aizved tieši uz motīvu izvēli, `unbloarchy menu toggle system` atver sistēmas izvēlni un aizver to atkal, ja tā jau ir atvērta, un `unbloarchy menu close` to aizver.
