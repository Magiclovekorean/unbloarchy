# Unbloarchy CLI

Unbloarchy styrs vanligtvis via snabbtangenterna och Unbloarchy-menyn (`Super + Space`). Men du kan också styra det via `unbloarchy` CLI. Det är särskilt hjälpsamt när du låter en AI-agent arbeta tillsammans med dig med anpassning eller konfiguration.

CLI:t har tillgång till alla interna verktyg som används både via menyn och på andra sätt. Du kan se allt som finns tillgängligt genom att köra `unbloarchy` i terminalen.

Det ser ut ungefär så här:

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

Och du kan gå djupare i varje grupp:

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

Varje kommando tar också `--help`, vare sig du frågar om en hel grupp (`unbloarchy capture --help`) eller ett enda kommando (`unbloarchy capture screenshot --help`).

### Öppna menyn från terminalen

Unbloarchy-menyn går också att skripta, vilket är praktiskt för dina egna tangentbindningar. `unbloarchy menu` öppnar den vid roten, och du kan hoppa direkt till vilken punkt som helst i trädet genom att namnge den: `unbloarchy menu summon appearance.theme` går rakt till temaväljaren, `unbloarchy menu toggle system` öppnar systemmenyn och stänger den igen om den redan är uppe, och `unbloarchy menu close` stänger den.
