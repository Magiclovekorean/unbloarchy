# Unbloarchy CLI

Unbloarchy se običajno upravlja prek bližnjičnih tipk in menija Unbloarchy (`Super + Space`). Lahko pa ga upravljate tudi prek CLI-ja `unbloarchy`. To je še posebej uporabno, ko z vami pri prilagajanju ali konfiguriranju sodeluje agent umetne inteligence.

CLI ima dostop do vseh notranjih orodij, ki se uporabljajo tako prek menija kot tudi sicer. Vse, kar je na voljo, si lahko ogledate tako, da v terminalu zaženete `unbloarchy`.

Videti je približno tako:

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

V vsako skupino pa se lahko poglobite še bolj:

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

Tudi vsak ukaz sprejema `--help`, ne glede na to, ali vprašate celotno skupino (`unbloarchy capture --help`) ali posamezen ukaz (`unbloarchy capture screenshot --help`).

### Odpiranje menija iz terminala

Meni Unbloarchy je mogoče tudi skriptirati, kar je priročno za vaše lastne bližnjice na tipkovnici. `unbloarchy menu` ga odpre v korenu, na katero koli točko v drevesu pa lahko skočite neposredno tako, da jo imenujete: `unbloarchy menu summon appearance.theme` gre naravnost do izbirnika tem, `unbloarchy menu toggle system` odpre sistemski meni in ga znova zapre, če je že odprt, `unbloarchy menu close` pa ga pospravi.
