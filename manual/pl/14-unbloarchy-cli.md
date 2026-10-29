# Unbloarchy CLI

Unbloarchy zwykle obsługuje się za pomocą skrótów klawiszowych i menu Unbloarchy (`Super + Space`). Można nią jednak sterować także przez CLI `unbloarchy`. Jest to szczególnie pomocne, gdy agent AI współpracuje z Tobą nad dostosowywaniem lub konfiguracją.

CLI ma dostęp do wszystkich wewnętrznych narzędzi używanych zarówno przez menu, jak i w inny sposób. Wszystko, co jest dostępne, zobaczysz po uruchomieniu `unbloarchy` w terminalu.

Wygląda to mniej więcej tak:

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

Możesz też zajrzeć głębiej do każdej grupy:

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

Każde polecenie przyjmuje też `--help`, niezależnie od tego, czy zapytasz o całą grupę (`unbloarchy capture --help`), czy o pojedyncze polecenie (`unbloarchy capture screenshot --help`).

### Otwieranie menu z terminala

Menu Unbloarchy można też obsługiwać skryptami, co przydaje się przy własnych skrótach klawiszowych. `unbloarchy menu` otwiera je na poziomie głównym, a podając nazwę, możesz przejść od razu do dowolnego miejsca w drzewie: `unbloarchy menu summon appearance.theme` prowadzi prosto do wyboru motywu, `unbloarchy menu toggle system` otwiera menu systemowe i zamyka je ponownie, jeśli jest już otwarte, a `unbloarchy menu close` je chowa.
