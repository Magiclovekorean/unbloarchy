# Unbloarchy CLI

Unbloarchy biasanya dikawal melalui kekunci pintas dan menu Unbloarchy (`Super + Space`). Tetapi anda juga boleh mengawalnya melalui CLI `unbloarchy`. Ini amat membantu apabila anda meminta ejen AI bekerjasama dengan anda untuk penyesuaian atau konfigurasi.

CLI ini mempunyai akses kepada semua perkakas dalaman yang digunakan melalui menu dan juga sebaliknya. Anda boleh melihat semua yang tersedia dengan menjalankan `unbloarchy` dalam terminal.

Ia kelihatan lebih kurang seperti ini:

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

Dan anda boleh menyelami setiap kumpulan dengan lebih mendalam:

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

Setiap arahan juga menerima `--help`, sama ada anda bertanya kepada keseluruhan kumpulan (`unbloarchy capture --help`) atau satu arahan sahaja (`unbloarchy capture screenshot --help`).

### Membuka menu dari terminal

Menu Unbloarchy juga boleh diskrip, yang berguna untuk ikatan kekunci anda sendiri. `unbloarchy menu` membukanya pada peringkat akar, dan anda boleh melompat terus ke mana-mana titik dalam pepohon dengan menamakannya: `unbloarchy menu summon appearance.theme` terus pergi ke pemilih tema, `unbloarchy menu toggle system` membuka menu sistem dan menutupnya semula jika ia sudah terbuka, dan `unbloarchy menu close` menyimpannya.
