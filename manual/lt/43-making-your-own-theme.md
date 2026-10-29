# Savo temos kūrimas

Savo temas galite įtraukti į `~/.config/unbloarchy/themes`. Tiesiog nukopijuokite vieną iš esamų kaip pagrindą (žiūrėkite `/usr/share/omarchy/themes`), tada koreguokite pagal savo skonį. Kol tema bus tame aplanke, ji bus įtraukta į temų pasirinkimo meniu.

Pagrindinis failas, kurį turite pakoreguoti, yra `colors.toml`. Jis apibrėžia spalvų rinkinį, kuris tada naudojamas terminalo (Foot/Alacritty/Ghostty/Kitty), btop, Chromium, Hyprland, Neovim, Helix, VSCode, Obsidian ir visos Unbloarchy aplinkos (viršutinės juostos, meniu, pranešimų, OSD ir užrakto ekrano) konfigūracijoms generuoti.

Norėdami sukurti naują temą, taip pat galite naudoti pateiktą Aether programą su miela GUI sąsaja, kurioje galėsite žaisti su spalvomis ir ieškoti fonų. Tiesiog paleiskite ją iš programų tinklelio paspaudę `Super + Alt + Space`.

### Ką gali turėti įdiegta tema

Tema, kurią patys parašote `~/.config/unbloarchy/themes`, gali turėti ką tik norite — tai jūsų kompiuteris ir jūsų failas, o Unbloarchy pritaikys viską.

Tema, kurią įdiegiate iš kažkieno kito repozitorijos su `unbloarchy theme install`, išlaiko viską, kas yra spalva, ir praranda saujelę failų, kurie jūsų kompiuteryje vykdytų kodą: bet kurį `.lua` failą, terminalo konfigūracijas (`alacritty.toml`, `foot.ini`, `ghostty.conf`, `kitty.conf`) ir `vscode.json`. Temos `hyprland.lua` yra Lua, kurią jūsų kompozitorius paleidžia prisijungiant, terminalo konfigūracija įvardija programą, kurią jūsų terminalas paleidžia, o `vscode.json` įvardija įdiegtiną VSCode plėtinį. Kažkieno kito temos įdiegimas turėtų pakeisti tai, kaip atrodo jūsų darbalaukis, bet niekada — tai, ką jis vykdo.

Visa kita ir toliau veikia lygiai taip, kaip parašė temos autorius — `btop.theme`, `chromium.theme`, `helix.toml`, `icons.theme`, `shell.toml`, fonai ir peržiūros išlieka. Tik tai, kas buvo pašalinta, jūsų kompiuteryje iš naujo sugeneruojama iš `colors.toml`.

Unbloarchy juodu atskiria pagal tai, ar tema savo viduje turi nuosavą git repozitoriją, kurią `unbloarchy theme install` palieka klonuodama. Taigi jūsų parašyta tema lieka jūsų, o parsisiųstoji iš interneto lieka spalvomis.

### Šviesusis režimas

Jei kuriate šviesiojo režimo temą, `colors.toml` viršuje nustatykite `mode = "light"`. Tada ji visoms programoms bus automatiškai susieta su šviesiuoju režimu. (Senasis būdas — į savo temos šakninį katalogą įmesti tuščią failą pavadinimu `light.mode` — taip pat vis dar veikia.)

### Piktogramų spalvos

Jei norite failų tvarkyklės piktogramų spalvas suderinti su savo tema, pridėkite failą pavadinimu `icons.theme` su norimo naudoti piktogramų rinkinio pavadinimu. Pagal numatytuosius nustatymus galimos šios parinktys: `Yaru Yaru-blue Yaru-dark Yaru-magenta Yaru-olive Yaru-prussiangreen Yaru-purple Yaru-red Yaru-sage Yaru-wartybrown Yaru-yellow`.

### Atrakinimo vaizdas

Temos, pateiktos su `unlock.png` ir `preview-unlock.png` vaizdais, bus rodomos skiltyje _Appearance > Unlock_. Jūsų `unlock.png` pageidautina turėtų būti skaidrus png. O peržiūros vaizdą galite sukurti naudodami `unbloarchy plymouth preview`.

### Programų, kurių Unbloarchy neapima, temų kūrimas

Jei naudojate programą, kurios nėra tame sąraše, galite patys išmokyti Unbloarchy ją teminti naudodami šabloną. Įmeskite failą į `~/.config/unbloarchy/themed/`, pavadintą pagal jo generuojamą konfigūraciją su plėtiniu `.tpl`, ir parašykite konfigūraciją su `{{ background }}`, `{{ foreground }}`, `{{ accent }}`, `{{ red }}`, `{{ color0 }}` iki `{{ color15 }}` ir likusia palete kaip rezervuotomis vietomis. Kiekvieną kartą perjungus temas, failas iš naujo sugeneruojamas su tos temos spalvomis.

Tame aplanke yra išsamiai pakomentuotas `alacritty.toml.tpl.sample`, nuo kurio galite kopijuoti — jame surašyti visi kintamieji, kuriuos galite naudoti, taip pat `_strip` ir `_rgb` modifikatoriai programoms, kurios nori spalvų be `#` arba dešimtainiu RGB formatu. Jūsų šablonai turi pirmenybę prieš Unbloarchy šablonus, todėl taip taip pat galite perrašyti, kaip temą gauna integruota programa.

### Savo temos platinimas

Jei norite platinti savo temą, kad ją galėtų naudoti kiti, turite ją įkelti į viešą git serverį, pavyzdžiui, GitHub. Tada žmonės galės ją įdiegti Unbloarchy meniu per _Install > Style > Theme_, naudodami tą URL. Rekomenduojama laikytis pavadinimų tvarkos `unbloarchy-[themename]-theme`, nes po įdiegimo temų pasirinkimo meniu tema bus teisingai rodoma tik kaip `[themename]`.

Tas likęs `[themename]` tampa temos katalogo pavadinimu, todėl jis turi būti toks, kurį Unbloarchy galėtų saugiai perduoti: jis turi prasidėti raide, skaitmeniu arba pabraukimo brūkšniu, o likusią dalį gali sudaryti raidės, skaitmenys, `.`, `_`, `+` ir `-`. Didžiosios raidės jums bus paverstos mažosiomis, tačiau visa kita — tarpas, kabutė, neangliškas rašmuo — diegimo metu bus atmesta, o ne paversta katalogo pavadinimu. Taigi `unbloarchy-tokyo-night-theme`, `unbloarchy-flexoki_light-theme` ir `unbloarchy-c++-theme` įsidiegia be problemų.

Atminkite, kad vos įdiegus iš repozitorijos, bet koks jos pateikiamas `.lua`, terminalo konfigūracija arba `vscode.json` yra pašalinamas, todėl temos aplink juos nekurkite.

Savo temą galite įtraukti į [papildomų temų puslapį](https://omarchy.org/themes/) pateikdami pull request į [omarchy-site repozitoriją](https://github.com/omacom-io/omarchy-site).
