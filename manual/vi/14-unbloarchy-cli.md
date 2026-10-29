# Unbloarchy CLI

Unbloarchy thường được điều khiển qua các phím tắt và menu Unbloarchy (`Super + Space`). Nhưng bạn cũng có thể điều khiển nó qua CLI `unbloarchy`. Điều này đặc biệt hữu ích khi bạn đang để một AI agent làm việc cùng bạn về tùy chỉnh hoặc cấu hình.

CLI có quyền truy cập vào toàn bộ công cụ nội bộ được dùng cả qua menu lẫn theo các cách khác. Bạn có thể thấy mọi thứ có sẵn bằng cách chạy `unbloarchy` trong terminal.

Nó trông đại khái như thế này:

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

Và bạn có thể đi sâu hơn vào từng nhóm:

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

Mọi lệnh cũng đều nhận `--help`, dù bạn hỏi cả một nhóm (`unbloarchy capture --help`) hay một lệnh đơn lẻ (`unbloarchy capture screenshot --help`).

### Mở menu từ terminal

Menu Unbloarchy cũng có thể được điều khiển bằng script, điều này rất tiện cho các keybinding của riêng bạn. `unbloarchy menu` mở nó ở cấp gốc, và bạn có thể nhảy thẳng đến bất kỳ điểm nào trong cây bằng cách gọi tên nó: `unbloarchy menu summon appearance.theme` đi thẳng đến trình chọn theme, `unbloarchy menu toggle system` mở menu hệ thống và đóng lại nếu nó đang mở, và `unbloarchy menu close` đóng nó đi.
