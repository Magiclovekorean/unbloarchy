# Unbloarchy CLI

Unbloarchy genellikle kısayol tuşları ve Unbloarchy menüsü (`Super + Space`) aracılığıyla kontrol edilir. Ancak onu `unbloarchy` CLI aracılığıyla da kontrol edebilirsiniz. Bu, özellikle bir AI agent ile birlikte özelleştirme veya yapılandırma üzerinde çalışırken faydalıdır.

CLI, hem menü aracılığıyla hem de başka yollarla kullanılan tüm dahili araçlara erişebilir. Terminalde `unbloarchy` çalıştırarak mevcut olan her şeyi görebilirsiniz.

Görünümü aşağı yukarı şöyledir:

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

Ve her grubun derinliklerine de inebilirsiniz:

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

Her komut `--help` de kabul eder; ister bütün bir grubu (`unbloarchy capture --help`) ister tek bir komutu (`unbloarchy capture screenshot --help`) sorgulayın.

### Terminalden menüyü açma

Unbloarchy menüsü de scriptlenebilir; bu, kendi tuş atamalarınız için kullanışlıdır. `unbloarchy menu` onu kök düzeyde açar ve adını belirterek ağacın herhangi bir noktasına doğrudan atlayabilirsiniz: `unbloarchy menu summon appearance.theme` doğrudan tema seçiciye gider, `unbloarchy menu toggle system` sistem menüsünü açar ve zaten açıksa tekrar kapatır, `unbloarchy menu close` ise onu ortadan kaldırır.
