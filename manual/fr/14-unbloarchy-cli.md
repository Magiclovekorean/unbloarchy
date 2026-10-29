# Unbloarchy CLI

Unbloarchy se contrôle habituellement via les raccourcis clavier et le menu Unbloarchy (`Super + Space`). Mais vous pouvez aussi le contrôler via la CLI `unbloarchy`. C'est particulièrement utile lorsque vous faites travailler un agent IA avec vous sur la personnalisation ou la configuration.

La CLI a accès à tous les outils internes utilisés à la fois via le menu et autrement. Vous pouvez voir tout ce qui est disponible en exécutant `unbloarchy` dans le terminal.

Cela ressemble à quelque chose comme ceci :

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

Et vous pouvez explorer chaque groupe plus en détail :

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

Chaque commande accepte aussi `--help`, que vous interrogiez un groupe entier (`unbloarchy capture --help`) ou une seule commande (`unbloarchy capture screenshot --help`).

### Ouvrir le menu depuis le terminal

Le menu Unbloarchy est également scriptable, ce qui est pratique pour vos propres raccourcis clavier. `unbloarchy menu` l'ouvre à la racine, et vous pouvez sauter directement à n'importe quel point de l'arborescence en le nommant : `unbloarchy menu summon appearance.theme` va directement au sélecteur de thème, `unbloarchy menu toggle system` ouvre le menu système et le referme s'il est déjà affiché, et `unbloarchy menu close` le masque.
