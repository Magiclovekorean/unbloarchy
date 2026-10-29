# Unbloarchy CLI

O Unbloarchy é normalmente controlado através das teclas de atalho e do menu Unbloarchy (`Super + Space`). Mas também pode controlá-lo através da CLI `unbloarchy`. Isto é particularmente útil quando tem um agente de IA a trabalhar consigo na personalização ou na configuração.

A CLI tem acesso a todas as ferramentas internas utilizadas tanto através do menu como de outras formas. Pode ver tudo o que está disponível executando `unbloarchy` no terminal.

Tem um aspeto semelhante a este:

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

E pode aprofundar cada grupo:

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

Todos os comandos também aceitam `--help`, quer pergunte a um grupo inteiro (`unbloarchy capture --help`) quer a um único comando (`unbloarchy capture screenshot --help`).

### Abrir o menu a partir do terminal

O menu Unbloarchy também pode ser controlado por script, o que é útil para os seus próprios atalhos de teclado. `unbloarchy menu` abre-o na raiz, e pode saltar diretamente para qualquer ponto da árvore indicando o respetivo nome: `unbloarchy menu summon appearance.theme` vai diretamente para o seletor de temas, `unbloarchy menu toggle system` abre o menu do sistema e volta a fechá-lo se já estiver aberto, e `unbloarchy menu close` fecha-o.
