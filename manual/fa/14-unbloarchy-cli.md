# Unbloarchy CLI

Unbloarchy معمولاً از طریق کلیدهای میانبر و منوی Unbloarchy (`Super + Space`) کنترل می‌شود. اما می‌توانید آن را از طریق CLI `unbloarchy` هم کنترل کنید. این به‌ویژه زمانی مفید است که یک عامل هوش مصنوعی را برای همکاری با خودتان در سفارشی‌سازی یا پیکربندی به کار می‌گیرید.

CLI به همه ابزارهای داخلی‌ای دسترسی دارد که هم از طریق منو و هم به روش‌های دیگر استفاده می‌شوند. با اجرای `unbloarchy` در ترمینال می‌توانید همه چیزهای در دسترس را ببینید.

چیزی شبیه این است:

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

و می‌توانید در هر گروه عمیق‌تر هم بشوید:

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

هر فرمان `--help` را هم می‌پذیرد، چه از یک گروه کامل بپرسید (`unbloarchy capture --help`) و چه از یک فرمان منفرد (`unbloarchy capture screenshot --help`).

### باز کردن منو از ترمینال

منوی Unbloarchy قابل اسکریپت‌نویسی هم هست، که برای میانبرهای صفحه‌کلید خودتان به کار می‌آید. `unbloarchy menu` آن را از ریشه باز می‌کند، و می‌توانید با نام بردن از آن مستقیم به هر نقطه‌ای از درخت بروید: `unbloarchy menu summon appearance.theme` مستقیم به انتخاب‌گر تم می‌رود، `unbloarchy menu toggle system` منوی سیستم را باز می‌کند و اگر از قبل باز باشد دوباره آن را می‌بندد، و `unbloarchy menu close` آن را کنار می‌گذارد.
