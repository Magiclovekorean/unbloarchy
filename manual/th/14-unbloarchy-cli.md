# Unbloarchy CLI

โดยปกติแล้ว Unbloarchy จะควบคุมผ่านปุ่มลัดและเมนู Unbloarchy (`Super + Space`) แต่คุณก็ควบคุมมันผ่าน `unbloarchy` CLI ได้เช่นกัน วิธีนี้มีประโยชน์เป็นพิเศษเมื่อคุณให้ AI agent มาช่วยปรับแต่งหรือตั้งค่าต่าง ๆ ไปพร้อมกับคุณ

CLI เข้าถึงเครื่องมือภายในทั้งหมดที่ใช้ทั้งผ่านเมนูและช่องทางอื่น ๆ ได้ คุณดูทุกอย่างที่มีให้ใช้ได้ด้วยการรัน `unbloarchy` ในเทอร์มินัล

หน้าตาของมันจะเป็นประมาณนี้:

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

และคุณยังเจาะลึกลงไปได้ในทุกกลุ่ม:

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

ทุกคำสั่งยังใช้ `--help` ได้เช่นกัน ไม่ว่าคุณจะถามทั้งกลุ่ม (`unbloarchy capture --help`) หรือถามคำสั่งเดียว (`unbloarchy capture screenshot --help`)

### การเปิดเมนูจากเทอร์มินัล

เมนู Unbloarchy ก็สั่งงานด้วยสคริปต์ได้เช่นกัน ซึ่งสะดวกมากสำหรับ keybindings ของคุณเอง `unbloarchy menu` จะเปิดเมนูที่จุดเริ่มต้น และคุณก็ข้ามตรงไปยังจุดใดก็ได้ในโครงสร้างเมนูด้วยการระบุชื่อจุดนั้น: `unbloarchy menu summon appearance.theme` จะพาคุณตรงไปยังตัวเลือกธีมทันที `unbloarchy menu toggle system` จะเปิดเมนูระบบ และปิดมันอีกครั้งหากเปิดอยู่แล้ว และ `unbloarchy menu close` จะปิดเมนูทิ้งไป
