# Unbloarchy CLI

Unbloarchy کو عام طور پر hotkeys اور Unbloarchy menu (`Super + Space`) کے ذریعے کنٹرول کیا جاتا ہے۔ لیکن آپ اسے `unbloarchy` CLI کے ذریعے بھی کنٹرول کر سکتے ہیں۔ یہ خاص طور پر اس وقت مددگار ہوتا ہے جب آپ کسی AI agent سے customization یا configuration پر اپنے ساتھ کام کروا رہے ہوں۔

CLI کو ان تمام internal tooling تک رسائی حاصل ہے جو menu کے ذریعے اور اس کے علاوہ بھی استعمال ہوتی ہیں۔ آپ terminal میں `unbloarchy` چلا کر ہر دستیاب چیز دیکھ سکتے ہیں۔

یہ کچھ اس طرح نظر آتا ہے:

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

اور آپ ہر group میں مزید گہرائی تک جا سکتے ہیں:

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

ہر command `--help` بھی لیتا ہے، چاہے آپ پورے group سے پوچھیں (`unbloarchy capture --help`) یا کسی ایک command سے (`unbloarchy capture screenshot --help`)۔

### Terminal سے menu کھولنا

Unbloarchy menu کو script بھی کیا جا سکتا ہے، جو آپ کی اپنی keybindings کے لیے کارآمد ہے۔ `unbloarchy menu` اسے root پر کھولتا ہے، اور آپ اس کا نام دے کر tree میں سیدھا کسی بھی مقام پر جا سکتے ہیں: `unbloarchy menu summon appearance.theme` سیدھا theme picker پر جاتا ہے، `unbloarchy menu toggle system` system menu کھولتا ہے اور اگر وہ پہلے سے کھلا ہو تو اسے پھر سے بند کر دیتا ہے، اور `unbloarchy menu close` اسے ہٹا دیتا ہے۔
