# Unbloarchy CLI

عادةً ما يتم التحكّم في Unbloarchy عبر مفاتيح الاختصار وقائمة Unbloarchy ‏(`Super + Space`). لكن يمكنك أيضًا التحكّم فيه عبر واجهة سطر الأوامر `unbloarchy` CLI. وهذا مفيد بشكل خاص عندما تجعل وكيل ذكاء اصطناعي يعمل معك على التخصيص أو الإعداد.

تتمتّع واجهة سطر الأوامر بإمكانية الوصول إلى جميع الأدوات الداخلية المستخدمة سواء عبر القائمة أو بغير ذلك. يمكنك رؤية كل ما هو متاح بتشغيل `unbloarchy` في الطرفية.

يبدو الأمر على نحو شبيه بهذا:

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

ويمكنك التعمّق أكثر في كل مجموعة:

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

يقبل كل أمر أيضًا `--help`، سواء طلبت مجموعة كاملة (`unbloarchy capture --help`) أو أمرًا واحدًا (`unbloarchy capture screenshot --help`).

### فتح القائمة من الطرفية

قائمة Unbloarchy قابلة للبرمجة النصية أيضًا، وهو أمر مفيد لاختصارات لوحة المفاتيح الخاصة بك. يفتح `unbloarchy menu` القائمة من الجذر، ويمكنك الانتقال مباشرة إلى أي نقطة في الشجرة بتسميتها: ينقلك `unbloarchy menu summon appearance.theme` مباشرة إلى منتقي السمات، ويفتح `unbloarchy menu toggle system` قائمة النظام ويغلقها مجددًا إذا كانت مفتوحة بالفعل، ويغلق `unbloarchy menu close` القائمة ويخفيها.
