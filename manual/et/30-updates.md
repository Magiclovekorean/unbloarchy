# Uuendused

Unbloarchyt ja sinu pakette hoitakse ajakohasena Unbloarchy menüü valiku _Uuenda > Unbloarchy_ kaudu (`Super + Space`).

Unbloarchy ise on paigaldatud tavaliste pacman pakettidena [Unbloarchy Package Repository](https://github.com/omacom-io/omarchy-pkgs) hoidlast, nii et uuendus paigaldab [uusima Unbloarchy väljaande](https://github.com/omacom/omarchy/releases), käivitab kõik ootel migratsioonid, et sinu süsteem uusimaga sünkrooni viia, ja uuendab kõik süsteemipaketid [Unbloarchy Arch Mirror](https://github.com/omacom-io/omarchy-mirror) peeglist ja [AUR](https://aur.archlinux.org/) hoidlast (kui oled paigaldanud mõne AUR paketi).

Kui uued väljaanded ilmuvad, ilmub sinu kella paremale poole ringnoole ikoon. Klõpsa seda ja uuendusprotsess algab.

![update-available](images/update-available.webp)

### Neli kanalit

Unbloarchyt uuendatakse nelja kanali kaudu: stable, RC, edge ja dev. Uued paigaldused alustavad stable kanalil, mis jälgib [ametlikke väljaandeid](https://github.com/omacom/omarchy/releases/), samuti [stabiilset Unbloarchy Arch peeglit](https://github.com/omacom-io/omarchy-mirror), mis on uusimast ühe kuu võrra maas, et saaksime tabada kõik uued ühildumatused, mis nõuavad konfiguratsioonimuudatusi, enne kui need inimestele probleeme põhjustavad.

Aga kui soovid aidata neid võimalikke probleeme märgata, võid kasutada edge kanalit. See hoiab sinu Unbloarchy paketid uusimate arendusjärgude juures ja laseb sul uuendada uusimatele Arch pakettidele kohe, kui need kättesaadavaks saavad. Peaksid seda tegema ainult siis, kui oled Linuxiga kogenud ja tead, kuidas probleemidega süsteemi taastada.

Enne iga uut suuremat väljaannet teeme lõpliku kontrolli RC kanali abil. Kui oled huvitatud lõpliku lihvi andmisel aitamisest, tule Discordi kanalile #unbloarchy-release-candidates.

Lõpuks on olemas dev kanal, mis seob Unbloarchy otse lähtekoodi git väljavõttega kaustas `~/unbloarchy`, kombineerituna edge pakettidega. Peaksid seda kanalit kasutama ainult siis, kui oled kogenud Linuxi kasutaja, töötad otse Unbloarchy kallal ja oled valmis katkestusi taluma.

Kanalite vahel saad vahetada Unbloarchy menüü valiku _Uuenda > Kanal_ kaudu (või terminalis käsuga `unbloarchy-channel-set`).

### Kernelite vahetamine

Unbloarchy käivitub oma `linux-omarchy` kerneliga, aga võid selle kõrvale paigaldatuna hoida teisi, näiteks Arch tavalist `linux` kernelit või katsetatavat eksperimentaalset järku. Kui neid on rohkem kui üks, loetleb Unbloarchy menüü valik _Uuenda > Kernel_ need üles ja vaikimisi käivituva kõrval on linnuke. Vali teine, sisesta üks kord oma parool ja see käivitub pärast järgmist taaskäivitust. Teised kernelid jäävad käivitusmenüüsse alles, nii et saad ikka käsitsi ühe valida, kui uus vaikevalik sulle probleeme tekitab. Terminalis näitab `unbloarchy-kernel` praegust vaikevalikut, `unbloarchy-kernel list` näitab, mis on paigaldatud, ja `unbloarchy-kernel set <kernel>` vahetab seda.

### Püsivara uuendused

Ainult sinu paketid ei jää vanaks. Paljud sülearvutid ja välisseadmed pakuvad BIOS, SSD ja doki püsivara Linux Vendor Firmware Service kaudu ning Unbloarchy menüü valik _Uuenda > Püsivara_ toob ja paigaldab kõik, mis sinu riistvara jaoks ootel on. Esimesel käivitamisel paigaldab see `fwupd`. Suurt osa püsivarast saab kirjutada ainult taaskäivituse ajal, nii et ära imesta, kui sinult üht küsitakse.

### Hoiatus otseste pacman/yay uuenduste kohta

Kui oled Archiga juba tuttav, võib tekkida kiusatus käivitada lihtsalt ise `pacman -Syu` või `yay -Syu`, aga kui sa seda teed, jääd ilma hetktõmmisest, migratsioonidest ja konfiguratsiooniuuendustest, mida Unbloarchy koos uute pakettidega käivitab. Seetõttu peatab Unbloarchy otsese süsteemiuuenduse ja suunab su hoopis käsu `unbloarchy update` juurde. (Kui sa tõesti tead, mida teed, ütleb kaitse sulle, kuidas sellest ühe tehingu puhul mööda minna.)

### Halbade uuenduste tagasipööramine

Kui sul tekib pärast uuendamist kunagi probleem, saad oma süsteemi tagasi pöörata enne uuendust tehtud hetktõmmisele. Lihtsalt taaskäivita ja vali käivituslaaduri menüüst hetktõmmis ajast enne uuendamise alustamist.

![bootloader](images/bootloader.webp)

Kui sinu konfiguratsioonifailid on kuidagi rikutud, saad terminalis käsuga `unbloarchy reinstall` teha ka Unbloarchy uuesti paigaldamise. See paigaldab uuesti kõik Unbloarchy vaikepaketid, paneb su stable kanalile ja alandab kõik liiga uued paketid ning lähtestab kõik konfiguratsioonifailid. Pane tähele, et seda tehes kirjutatakse üle kõik sinu kasutajapoolsed muudatused Unbloarchy vaikeväärtustes!
