# Oppdateringer

Unbloarchy og pakkene dine holdes oppdatert via _Oppdater > Unbloarchy_ i Unbloarchy-menyen (`Super + Space`).

Unbloarchy selv er installert som vanlige pacman-pakker fra [Unbloarchy Package Repository](https://github.com/omacom-io/omarchy-pkgs), så en oppdatering installerer [den nyeste Unbloarchy-utgivelsen](https://github.com/omacom/omarchy/releases), kjører eventuelle ventende migreringer for å få systemet ditt i synk med det nyeste, og oppdaterer alle systempakker fra [Unbloarchy Arch Mirror](https://github.com/omacom-io/omarchy-mirror) og [AUR](https://aur.archlinux.org/) (hvis du har installert noen AUR-pakker).

Når nye utgivelser blir lansert, vil et sirkelpil-ikon dukke opp til høyre for klokken din. Klikk på det, så starter oppdateringsprosessen.

![update-available](images/update-available.webp)

### Fire kanaler

Unbloarchy oppdateres langs fire kanaler: stable, RC, edge og dev. Nye installasjoner starter på stable-kanalen, som følger de [offisielle utgivelsene](https://github.com/omacom/omarchy/releases/), samt det [stabile Unbloarchy Arch-speilet](https://github.com/omacom-io/omarchy-mirror) som ligger én måned bak det nyeste, slik at vi kan fange opp eventuelle nye inkompatibiliteter som krever konfigurasjonsendringer før de skaper problemer for folk.

Men hvis du vil hjelpe til med å oppdage de potensielle problemene, kan du kjøre på edge-kanalen. Da vil Unbloarchy-pakkene dine følge de nyeste utviklingsbyggene, og du kan oppdatere til de nyeste Arch-pakkene så snart de er tilgjengelige. Du bør bare gjøre dette hvis du er erfaren med Linux og vet hvordan du gjenoppretter et system som har problemer.

Før hver nye større utgivelse vil vi gjøre siste validering med RC-kanalen. Hvis du er interessert i å hjelpe til med siste finpuss, kom og heng i #unbloarchy-release-candidates på Discord.

Til slutt er det dev-kanalen, som kobler Unbloarchy direkte til en git-utsjekking av kildekoden i `~/unbloarchy`, kombinert med edge-pakkene. Du bør bare bruke denne kanalen hvis du er en erfaren Linux-bruker, jobber direkte på Unbloarchy og er villig til å tåle at ting går i stykker.

Du kan bytte mellom kanaler med _Oppdater > Kanal_ fra Unbloarchy-menyen (eller `unbloarchy-channel-set` i terminalen).

### Bytte kjerner

Unbloarchy starter med sin egen `linux-omarchy`-kjerne, men du kan ha andre installert ved siden av den, som standard Arch-`linux`-kjernen eller et eksperimentelt bygg du tester. Når det finnes mer enn én, lister _Oppdater > Kjerne_ i Unbloarchy-menyen dem med en hake ved den som starter som standard. Velg en annen, skriv inn passordet ditt én gang, så starter den etter neste omstart. De andre kjernene blir værende i oppstartsmenyen, så du kan fortsatt velge en for hånd hvis den nye standarden gir deg trøbbel. I terminalen er det `unbloarchy-kernel` for å se gjeldende standard, `unbloarchy-kernel list` for hva som er installert, og `unbloarchy-kernel set <kernel>` for å bytte.

### Fastvareoppdateringer

Pakkene dine er ikke det eneste som blir utdatert. Mange bærbare datamaskiner og eksterne enheter leverer BIOS-, SSD- og dokking-fastvare gjennom Linux Vendor Firmware Service, og _Oppdater > Fastvare_ i Unbloarchy-menyen henter og installerer det maskinvaren din har ventende. Den installerer `fwupd` første gang du kjører den. Mye fastvare kan bare skrives under en omstart, så ikke bli overrasket om du blir bedt om en.

### Advarsel om direkte pacman/yay-oppdateringer

Hvis du allerede kjenner Arch, kan du bli fristet til å bare kjøre `pacman -Syu` eller `yay -Syu` selv, men hvis du gjør det, går du glipp av snapshotet, migreringene og konfigurasjonsoppdateringene som Unbloarchy kjører sammen med nye pakker. Derfor vil Unbloarchy faktisk stoppe en direkte systemoppgradering og vise deg til `unbloarchy update` i stedet. (Hvis du virkelig vet hva du driver med, vil sperren fortelle deg hvordan du omgår den for én enkelt transaksjon.)

### Rulle tilbake dårlige oppdateringer

Hvis du noen gang får et problem etter å ha gjort en oppdatering, kan du rulle tilbake systemet ditt til snapshotet som ble tatt før oppdateringen. Bare start på nytt og velg snapshotet i oppstartsmenyen fra før du startet oppdateringen.

![bootloader](images/bootloader.webp)

Hvis konfigurasjonsfilene dine på en eller annen måte har blitt ødelagt, kan du også reinstallere Unbloarchy med `unbloarchy reinstall` i terminalen. Dette vil reinstallere alle standard Unbloarchy-pakkene, sette deg på stable og nedgradere eventuelle pakker som er for nye, og tilbakestille alle konfigurasjonsfilene. Merk at alle endringene dine i brukerkonfigurasjonen av Unbloarchy-standardene vil bli overskrevet når du gjør dette!
