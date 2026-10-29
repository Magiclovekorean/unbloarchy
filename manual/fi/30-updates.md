# Päivitykset

Unbloarchy ja pakettisi pidetään ajan tasalla Unbloarchy-valikon kohdasta _Päivitä > Unbloarchy_ (`Super + Space`).

Unbloarchy itse asennetaan tavallisina pacman-paketteina [Unbloarchy-pakettivarastosta](https://github.com/omacom-io/omarchy-pkgs), joten päivitys asentaa [uusimman Unbloarchy-julkaisun](https://github.com/omacom/omarchy/releases), suorittaa kaikki odottavat migraatiot järjestelmäsi synkronoimiseksi uusimman version kanssa ja päivittää kaikki järjestelmäpaketit [Unbloarchy Arch -peilistä](https://github.com/omacom-io/omarchy-mirror) ja [AUR:sta](https://aur.archlinux.org/) (jos olet asentanut AUR-paketteja).

Kun uusia julkaisuja ilmestyy, kellosi oikealle puolelle ilmestyy ympyränuolikuvake. Napsauta sitä, niin päivitysprosessi käynnistyy.

![update-available](images/update-available.webp)

### Neljä kanavaa

Unbloarchy päivitetään neljällä kanavalla: stable, RC, edge ja dev. Uudet asennukset alkavat stable-kanavalla, joka seuraa [virallisia julkaisuja](https://github.com/omacom/omarchy/releases/) sekä [vakaata Unbloarchy Arch -peiliä](https://github.com/omacom-io/omarchy-mirror), joka kulkee kuukauden uusinta jäljessä, jotta voimme havaita kaikki uudet yhteensopimattomuudet, jotka vaativat määritysmuutoksia, ennen kuin ne aiheuttavat ongelmia ihmisille.

Mutta jos haluat auttaa havaitsemaan nuo mahdolliset ongelmat, voit käyttää edge-kanavaa. Se pitää Unbloarchy-pakettisi uusimpien kehitysversioiden tasalla ja antaa sinun päivittää uusimpiin Arch-paketteihin heti, kun ne ovat saatavilla. Tee näin vain, jos olet kokenut Linux-käyttäjä ja osaat palauttaa järjestelmän, jossa on ongelmia.

Ennen jokaista uutta suurta julkaisua teemme lopullisen validoinnin RC-kanavalla. Jos olet kiinnostunut auttamaan viimeistelyssä, tule viettämään aikaa Discordissa kanavalle #unbloarchy-release-candidates.

Lopuksi on dev-kanava, joka linkittää Unbloarchyn suoraan lähdekoodin git-kopioon kansiossa `~/unbloarchy` yhdistettynä edge-paketteihin. Käytä tätä kanavaa vain, jos olet kokenut Linux-käyttäjä, työskentelet suoraan Unbloarchyn parissa ja olet valmis sietämään rikkoutumisia.

Voit vaihtaa kanavaa Unbloarchy-valikon kohdasta _Päivitä > Kanava_ (tai komennolla `unbloarchy-channel-set` terminaalissa).

### Ytimen vaihtaminen

Unbloarchy käynnistää oman `linux-omarchy`-ytimensä, mutta voit pitää sen rinnalla muitakin asennettuina, kuten Archin vakioytimen `linux` tai kokeellisen version, jota testaat. Kun ytimiä on useampi kuin yksi, Unbloarchy-valikon _Päivitä > Ydin_ listaa ne ja näyttää valintamerkin sen vieressä, joka käynnistyy oletuksena. Valitse toinen, syötä salasanasi kerran, ja se käynnistyy seuraavan uudelleenkäynnistyksen jälkeen. Muut ytimet pysyvät käynnistysvalikossa, joten voit silti valita sellaisen käsin, jos uusi oletus aiheuttaa ongelmia. Terminaalissa `unbloarchy-kernel` näyttää nykyisen oletuksen, `unbloarchy-kernel list` asennetut ytimet ja `unbloarchy-kernel set <kernel>` vaihtaa ytimen.

### Laiteohjelmistopäivitykset

Pakettisi eivät ole ainoa asia, joka vanhenee. Monet kannettavat tietokoneet ja oheislaitteet toimittavat BIOS-, SSD- ja telakkalaiteohjelmistoja Linux Vendor Firmware Servicen kautta, ja Unbloarchy-valikon _Päivitä > Laiteohjelmisto_ hakee ja asentaa kaiken, mitä laitteistollesi on odottamassa. Se asentaa `fwupd`:n ensimmäisellä käyttökerralla. Paljon laiteohjelmistoja voidaan kirjoittaa vain uudelleenkäynnistyksen aikana, joten älä ylläty, jos sinua pyydetään käynnistämään uudelleen.

### Varoitus suorista pacman/yay-päivityksistä

Jos Arch on jo sinulle tuttu, saatat tuntea houkutusta ajaa itse vain `pacman -Syu` tai `yay -Syu`, mutta jos teet niin, ohitat tilannevedoksen, migraatiot ja määrityspäivitykset, jotka Unbloarchy ajaa yhdessä uusien pakettien kanssa. Siksi Unbloarchy itse asiassa pysäyttää suoran järjestelmäpäivityksen ja ohjaa sinut sen sijaan käyttämään komentoa `unbloarchy update`. (Jos todella tiedät, mitä olet tekemässä, suoja kertoo, miten sen voi ohittaa yhden tapahtuman ajaksi.)

### Huonojen päivitysten peruminen

Jos sinulla on koskaan ongelmia päivityksen tekemisen jälkeen, voit palauttaa järjestelmäsi päivitystä ennen otettuun tilannevedokseen. Käynnistä vain uudelleen ja valitse käynnistyslataimen valikosta tilannevedos ajalta ennen päivityksen aloittamista.

![bootloader](images/bootloader.webp)

Jos määritystiedostosi ovat jotenkin vioittuneet, voit myös asentaa Unbloarchyn uudelleen komennolla `unbloarchy reinstall` terminaalissa. Tämä asentaa uudelleen kaikki Unbloarchyn oletuspaketit, siirtää sinut stable-kanavalle ja alentaa liian uudet paketit vanhempiin versioihin sekä nollaa kaikki määritystiedostot. Huomaa, että kaikki Unbloarchyn oletuksiin tekemäsi käyttäjämääritysten muutokset ylikirjoitetaan tämän aikana!
