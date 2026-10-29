# Unbloarchy CLI

את Unbloarchy שולטים בדרך כלל דרך מקשי הקיצור והתפריט של Unbloarchy (`Super + Space`). אבל אפשר לשלוט בה גם דרך ה-CLI של `unbloarchy`. זה מועיל במיוחד כשסוכן AI עובד איתך על התאמה אישית או על תצורה.

ל-CLI יש גישה לכל הכלים הפנימיים שמשמשים גם דרך התפריט וגם בדרכים אחרות. אפשר לראות את כל מה שזמין על ידי הרצת `unbloarchy` בטרמינל.

זה נראה בערך ככה:

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

ואפשר לצלול עמוק יותר לכל קבוצה:

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

כל פקודה מקבלת גם `--help`, בין אם שואלים קבוצה שלמה (`unbloarchy capture --help`) או פקודה בודדת (`unbloarchy capture screenshot --help`).

### פתיחת התפריט מהטרמינל

גם בתפריט של Unbloarchy אפשר לשלוט באמצעות סקריפטים, וזה שימושי עבור מקשי הקיצור שלך. `unbloarchy menu` פותח אותו מהשורש, ואפשר לקפוץ ישר לכל נקודה בעץ על ידי ציון שמה: `unbloarchy menu summon appearance.theme` הולך ישר לבוחר ערכות הנושא, `unbloarchy menu toggle system` פותח את תפריט המערכת וסוגר אותו שוב אם הוא כבר פתוח, ו-`unbloarchy menu close` מסתיר אותו.
