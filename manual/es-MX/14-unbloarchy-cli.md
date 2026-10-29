# Unbloarchy CLI

Normalmente, Unbloarchy se controla mediante las teclas de acceso rápido y el menú de Unbloarchy (`Super + Space`). Pero también puedes controlarlo mediante la CLI `unbloarchy`. Esto es especialmente útil cuando tienes a un agente de IA trabajando contigo en la personalización o la configuración.

La CLI tiene acceso a todas las herramientas internas que se usan tanto desde el menú como por otros medios. Puedes ver todo lo que está disponible ejecutando `unbloarchy` en la terminal.

Se ve más o menos así:

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

Y puedes profundizar en cada grupo:

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

Todo comando también admite `--help`, ya sea que consultes un grupo completo (`unbloarchy capture --help`) o un solo comando (`unbloarchy capture screenshot --help`).

### Abrir el menú desde la terminal

El menú de Unbloarchy también se puede controlar mediante comandos, lo que viene bien para tus propios atajos de teclado. `unbloarchy menu` lo abre en la raíz, y puedes saltar directamente a cualquier punto del árbol nombrándolo: `unbloarchy menu summon appearance.theme` va directo al selector de temas, `unbloarchy menu toggle system` abre el menú del sistema y lo vuelve a cerrar si ya está abierto, y `unbloarchy menu close` lo oculta.
