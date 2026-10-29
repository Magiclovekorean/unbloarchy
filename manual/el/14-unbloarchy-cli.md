# Unbloarchy CLI

Το Unbloarchy συνήθως ελέγχεται μέσω των συντομεύσεων πληκτρολογίου και του μενού Unbloarchy (`Super + Space`). Μπορείς όμως να το ελέγχεις και μέσω του `unbloarchy` CLI. Αυτό είναι ιδιαίτερα χρήσιμο όταν δουλεύεις μαζί με έναν agent AI πάνω σε προσαρμογές ή ρυθμίσεις.

Το CLI έχει πρόσβαση σε όλα τα εσωτερικά εργαλεία που χρησιμοποιούνται τόσο μέσω του μενού όσο και με άλλους τρόπους. Μπορείς να δεις όλα όσα είναι διαθέσιμα τρέχοντας το `unbloarchy` στο τερματικό.

Μοιάζει κάπως έτσι:

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

Και μπορείς να ψάξεις βαθύτερα σε κάθε ομάδα:

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

Κάθε εντολή δέχεται επίσης το `--help`, είτε ρωτήσεις μια ολόκληρη ομάδα (`unbloarchy capture --help`) είτε μια μεμονωμένη εντολή (`unbloarchy capture screenshot --help`).

### Άνοιγμα του μενού από το τερματικό

Το μενού Unbloarchy μπορεί επίσης να κληθεί από σενάρια, κάτι που είναι βολικό για τις δικές σου συντομεύσεις πληκτρολογίου. Το `unbloarchy menu` το ανοίγει στη ρίζα, και μπορείς να πας κατευθείαν σε οποιοδήποτε σημείο του δέντρου ονομάζοντάς το: το `unbloarchy menu summon appearance.theme` πηγαίνει κατευθείαν στην επιλογή θέματος, το `unbloarchy menu toggle system` ανοίγει το μενού συστήματος και το κλείνει ξανά αν είναι ήδη ανοιχτό, και το `unbloarchy menu close` το κλείνει.
