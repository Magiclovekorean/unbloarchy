# Atjauninājumi

Unbloarchy un jūsu pakotnes tiek uzturētas aktuālas, izmantojot _Update > Unbloarchy_ Unbloarchy izvēlnē (`Super + Space`).

Pats Unbloarchy ir instalēts kā parastas pacman pakotnes no [Unbloarchy Package Repository](https://github.com/omacom-io/omarchy-pkgs), tāpēc atjauninājums instalē [jaunāko Unbloarchy laidienu](https://github.com/omacom/omarchy/releases), palaiž visas neizpildītās migrācijas, lai sinhronizētu jūsu sistēmu ar jaunāko versiju, un atjaunina visas sistēmas pakotnes no [Unbloarchy Arch Mirror](https://github.com/omacom-io/omarchy-mirror) un [AUR](https://aur.archlinux.org/) (ja esat instalējis kādas AUR pakotnes).

Kad tiek izlaisti jauni laidieni, pa labi no jūsu pulksteņa parādīsies apļa bultiņas ikona. Noklikšķiniet uz tās, un atjaunināšanas process sāksies.

![update-available](images/update-available.webp)

### Četri kanāli

Unbloarchy tiek atjaunināts četros kanālos: stable, RC, edge un dev. Jaunas instalācijas sākas kanālā stable, kas seko [oficiālajiem laidieniem](https://github.com/omacom/omarchy/releases/), kā arī [stabilajam Unbloarchy Arch mirror](https://github.com/omacom-io/omarchy-mirror), kas atpaliek no jaunākā par vienu mēnesi, lai mēs varētu pamanīt visas jaunās nesaderības, kurām nepieciešamas konfigurācijas izmaiņas, pirms tās rada problēmas cilvēkiem.

Bet, ja vēlaties palīdzēt pamanīt šīs iespējamās problēmas, varat izmantot kanālu edge. Tas uzturēs jūsu Unbloarchy pakotnes atbilstošas jaunākajiem izstrādes būvējumiem un ļaus jums atjaunināt uz jaunākajām Arch pakotnēm, tiklīdz tās kļūst pieejamas. To vajadzētu darīt tikai tad, ja jums ir pieredze ar Linux un zināt, kā atjaunot sistēmu, kurai ir problēmas.

Pirms katra jauna lielā laidiena mēs veiksim galīgo pārbaudi, izmantojot kanālu RC. Ja vēlaties palīdzēt ar galīgo noslīpēšanu, pievienojieties #unbloarchy-release-candidates kanālā Discord.

Visbeidzot, ir kanāls dev, kas saista Unbloarchy tieši ar git izrakstītu pirmkodu mapē `~/unbloarchy`, apvienojumā ar edge pakotnēm. Šo kanālu vajadzētu izmantot tikai tad, ja esat pieredzējis Linux lietotājs, strādājat tieši pie Unbloarchy un esat gatavs paciest bojājumus.

Starp kanāliem varat pārslēgties, izmantojot _Update > Channel_ Unbloarchy izvēlnē (vai `unbloarchy-channel-set` terminālī).

### Kodolu pārslēgšana

Unbloarchy palaiž savu `linux-omarchy` kodolu, bet blakus tam varat uzturēt instalētus citus, piemēram, standarta Arch `linux` kodolu vai eksperimentālu būvējumu, ko testējat. Ja ir vairāk nekā viens, _Update > Kernel_ Unbloarchy izvēlnē tos uzskaita ar atzīmi blakus tam, kas tiek palaists pēc noklusējuma. Izvēlieties citu, vienreiz ievadiet savu paroli, un tas tiks palaists pēc nākamās restartēšanas. Pārējie kodoli paliek sāknēšanas izvēlnē, tāpēc joprojām varat izvēlēties vienu manuāli, ja jaunais noklusējuma kodols rada jums problēmas. Terminālī `unbloarchy-kernel` parāda pašreizējo noklusējumu, `unbloarchy-kernel list` — kas ir instalēts, un `unbloarchy-kernel set <kernel>` — pārslēgšanai.

### Programmaparatūras atjauninājumi

Jūsu pakotnes nav vienīgais, kas noveco. Daudzi klēpjdatori un perifērijas ierīces nodrošina BIOS, SSD un dokstaciju programmaparatūru, izmantojot Linux Vendor Firmware Service, un _Update > Firmware_ Unbloarchy izvēlnē iegūs un instalēs visu, ko jūsu aparatūra gaida. Pirmajā palaišanas reizē tas instalē `fwupd`. Lielu daļu programmaparatūras var ierakstīt tikai restartēšanas laikā, tāpēc nebrīnieties, ja jums tiks lūgts restartēt.

### Brīdinājums par tiešiem pacman/yay atjauninājumiem

Ja jau pazīstat Arch, jums varētu rasties kārdinājums vienkārši pašam palaist `pacman -Syu` vai `yay -Syu`, bet, ja to darīsiet, jūs palaidīsiet garām momentuzņēmumu, migrācijas un konfigurācijas atjauninājumus, ko Unbloarchy palaiž kopā ar jaunajām pakotnēm. Tāpēc Unbloarchy faktiski apturēs tiešu sistēmas jaunināšanu un norādīs jums uz `unbloarchy update`. (Ja patiešām zināt, ko darāt, aizsargs jums pateiks, kā to apiet vienam darījumam.)

### Sliktu atjauninājumu atcelšana

Ja pēc atjaunināšanas jums kādreiz rodas problēma, varat atcelt sistēmu uz momentuzņēmumu, kas uzņemts pirms atjaunināšanas. Vienkārši restartējiet un sāknēšanas ielādes izvēlnē izvēlieties momentuzņēmumu no laika pirms atjaunināšanas sākšanas.

![bootloader](images/bootloader.webp)

Ja jūsu konfigurācijas faili kaut kā ir sabojāti, varat arī veikt Unbloarchy pārinstalēšanu, izmantojot `unbloarchy reinstall` terminālī. Tas pārinstalēs visas noklusējuma Unbloarchy pakotnes, pārslēgs jūs uz stable un pazeminās visas pakotnes, kas ir pārāk jaunas, kā arī atiestatīs visus konfigurācijas failus. Ņemiet vērā, ka visas jūsu lietotāja konfigurācijas izmaiņas Unbloarchy noklusējumos, to darot, tiks pārrakstītas!
