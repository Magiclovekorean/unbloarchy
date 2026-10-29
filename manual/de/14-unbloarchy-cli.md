# Unbloarchy CLI

Unbloarchy wird in der Regel über die Hotkeys und das Unbloarchy-Menü (`Super + Space`) gesteuert. Du kannst es aber auch über die `unbloarchy`-CLI steuern. Das ist besonders hilfreich, wenn ein KI-Agent mit dir an Anpassungen oder Konfiguration arbeitet.

Die CLI hat Zugriff auf alle internen Werkzeuge, die sowohl über das Menü als auch anderweitig verwendet werden. Du kannst alles Verfügbare sehen, indem du `unbloarchy` im Terminal ausführst.

Das sieht ungefähr so aus:

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

Und du kannst bei jeder Gruppe tiefer einsteigen:

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

Jeder Befehl akzeptiert auch `--help`, egal ob du eine ganze Gruppe (`unbloarchy capture --help`) oder einen einzelnen Befehl (`unbloarchy capture screenshot --help`) abfragst.

### Das Menü vom Terminal aus öffnen

Das Unbloarchy-Menü ist ebenfalls skriptbar, was für deine eigenen Tastenkombinationen praktisch ist. `unbloarchy menu` öffnet es auf der obersten Ebene, und du kannst direkt zu jedem Punkt im Baum springen, indem du ihn benennst: `unbloarchy menu summon appearance.theme` führt direkt zur Theme-Auswahl, `unbloarchy menu toggle system` öffnet das Systemmenü und schließt es wieder, wenn es bereits geöffnet ist, und `unbloarchy menu close` schließt es.
