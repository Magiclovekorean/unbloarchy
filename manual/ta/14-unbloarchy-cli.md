# Unbloarchy CLI

Unbloarchy பொதுவாக ஹாட்கீகள் மற்றும் Unbloarchy மெனு (`Super + Space`) வழியாகக் கட்டுப்படுத்தப்படுகிறது. ஆனால் `unbloarchy` CLI வழியாகவும் அதைக் கட்டுப்படுத்தலாம். தனிப்பயனாக்கம் அல்லது உள்ளமைவில் ஒரு AI agent உங்களுடன் இணைந்து பணியாற்றும்போது இது குறிப்பாகப் பயனுள்ளதாக இருக்கும்.

மெனு வழியாகவும் மற்றபடியும் பயன்படுத்தப்படும் அனைத்து உள் கருவிகளுக்கும் CLI அணுகலைக் கொண்டுள்ளது. டெர்மினலில் `unbloarchy` என இயக்குவதன் மூலம் கிடைக்கக்கூடிய அனைத்தையும் நீங்கள் காணலாம்.

இது இப்படி ஏதோ தோற்றமளிக்கும்:

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

மேலும் ஒவ்வொரு குழுவிலும் நீங்கள் ஆழமாகச் செல்லலாம்:

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

ஒட்டுமொத்த குழுவிடம் (`unbloarchy capture --help`) கேட்டாலும் சரி, ஒரே ஒரு கட்டளையிடம் (`unbloarchy capture screenshot --help`) கேட்டாலும் சரி, ஒவ்வொரு கட்டளையும் `--help` ஐயும் ஏற்கும்.

### டெர்மினலில் இருந்து மெனுவைத் திறத்தல்

Unbloarchy மெனுவையும் ஸ்கிரிப்ட் செய்யலாம்; உங்கள் சொந்த கீபைண்டிங்குகளுக்கு இது வசதியாக இருக்கும். `unbloarchy menu` அதை ரூட்டில் திறக்கும், மேலும் அதைப் பெயரிடுவதன் மூலம் மரத்தின் எந்தப் புள்ளிக்கும் நேரடியாகச் செல்லலாம்: `unbloarchy menu summon appearance.theme` நேராக தீம் பிக்கருக்குச் செல்கிறது, `unbloarchy menu toggle system` சிஸ்டம் மெனுவைத் திறக்கிறது, ஏற்கனவே அது திறந்திருந்தால் அதை மீண்டும் மூடுகிறது, மேலும் `unbloarchy menu close` அதை மூடி வைக்கிறது.
