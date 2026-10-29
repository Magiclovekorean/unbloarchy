# Unbloarchy CLI

Unbloarchy biasanya dikendalikan melalui hotkey dan menu Unbloarchy (`Super + Space`). Tapi kamu juga bisa mengendalikannya melalui CLI `unbloarchy`. Ini sangat membantu saat kamu meminta agen AI bekerja bersamamu dalam kustomisasi atau konfigurasi.

CLI ini punya akses ke semua perkakas internal yang digunakan baik melalui menu maupun cara lain. Kamu bisa melihat semua yang tersedia dengan menjalankan `unbloarchy` di terminal.

Tampilannya kurang lebih seperti ini:

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

Dan kamu bisa menyelami setiap grup lebih dalam:

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

Setiap perintah juga menerima `--help`, baik saat kamu menanyakan seluruh grup (`unbloarchy capture --help`) maupun satu perintah saja (`unbloarchy capture screenshot --help`).

### Membuka menu dari terminal

Menu Unbloarchy juga bisa diskrip, yang berguna untuk keybinding kamu sendiri. `unbloarchy menu` membukanya di root, dan kamu bisa langsung lompat ke titik mana pun di pohonnya dengan menyebut namanya: `unbloarchy menu summon appearance.theme` langsung menuju pemilih tema, `unbloarchy menu toggle system` membuka menu sistem dan menutupnya lagi jika sudah terbuka, dan `unbloarchy menu close` menyingkirkannya.
