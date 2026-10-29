# Unbloarchy CLI

Unbloarchy odatda tezkor tugmalar va Unbloarchy menyusi (`Super + Space`) orqali boshqariladi. Lekin uni `unbloarchy` CLI orqali ham boshqarishingiz mumkin. Bu, ayniqsa, moslashtirish yoki konfiguratsiya ustida siz bilan birga AI agent ishlayotganda juda qo‘l keladi.

CLI menyu orqali ham, boshqa yo‘llar bilan ham ishlatiladigan barcha ichki vositalarga kirish imkoniga ega. Mavjud barcha narsani terminalda `unbloarchy` ni ishga tushirib ko‘rishingiz mumkin.

Bu taxminan shunday ko‘rinadi:

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

Va har bir guruhga yanada chuqurroq kirishingiz mumkin:

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

Har bir buyruq `--help` ni ham qabul qiladi, xoh butun guruhni so‘rasangiz (`unbloarchy capture --help`), xoh bitta buyruqni so‘rasangiz (`unbloarchy capture screenshot --help`).

### Menyuni terminaldan ochish

Unbloarchy menyusini skript orqali ham boshqarish mumkin, bu o‘z tugmalar birikmalaringiz uchun qulay. `unbloarchy menu` uni ildizidan ochadi va uni nomlash orqali daraxtning istalgan nuqtasiga to‘g‘ridan-to‘g‘ri o‘tishingiz mumkin: `unbloarchy menu summon appearance.theme` to‘g‘ridan-to‘g‘ri mavzu tanlagichga o‘tadi, `unbloarchy menu toggle system` tizim menyusini ochadi va agar u allaqachon ochiq bo‘lsa, uni yana yopadi, `unbloarchy menu close` esa uni yopib qo‘yadi.
