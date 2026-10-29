# Rendszeralvás

Az Unbloarchy alapértelmezetten engedélyezi a felfüggesztést és a hibernálást, de ha bármelyikkel problémád van a gépeden, kikapcsolhatod őket.

Az NVIDIA GB10 gépeken, például a DGX Spark és az ASUS Ascent GX10 esetében a felfüggesztés és a hibernálás ki van kapcsolva, ahogyan az NVIDIA DGX OS rendszerében is, mert még nem bizonyított, hogy az alvás működik ezen a hardveren. A felfüggesztés kapcsolója és a hibernálás beállítása ott nem érvényes. Az alvás visszakapcsolásához távolítsd el az `/etc/systemd/sleep.conf.d/unbloarchy-sleep-disabled.conf` fájlt a `sudo rm` paranccsal; a Felfüggesztés ezután visszatér a menübe, a hibernálás pedig a többi géphez hasonlóan beállítható. A `sudo unbloarchy apply hardware --install-user "$USER"` parancs futtatása visszahelyezi a fájlt.

### Energiaprofilok

Laptopon az Unbloarchy külön megjegyzi az energiaprofilodat hálózatra csatlakoztatott és akkumulátorról működő állapothoz, és a csatlakoztatáskor és kihúzáskor vált a kettő között. Ez alapból teljesítményt jelent hálózati tápellátáson, és kiegyensúlyozott módot akkumulátoron.

Az `unbloarchy powerprofiles list` paranccsal megnézheted, mit kínál a géped, és az `unbloarchy powerprofiles set autodetect power-saver` paranccsal beállíthatod a kívántat ahhoz az állapothoz, amelyben éppen vagy. Ha a másik állapotot szeretnéd beállítani anélkül, hogy bármit kihúznál, nevezd meg közvetlenül: `unbloarchy powerprofiles set battery power-saver`. Amit választasz, azt kapod vissza legközelebb, amikor abban az állapotban leszel.

### Felfüggesztés ki-/bekapcsolása

A felfüggesztést az `unbloarchy toggle suspend` terminálban történő futtatásával kapcsolhatod át. Ez csak megjeleníti/elrejti a lehetőséget a _Rendszer_ alatt (vagy a `Super + Esc` billentyűkombinációval), ezután pedig megnézheted, következetesen működik-e a rendszereden. Ha nem, ugyanezzel a paranccsal ismét elrejtheted.

### Hibernálás ki-/bekapcsolása

A hibernálást az `unbloarchy hibernation setup` terminálban történő futtatásával állíthatod be. A hibernálás egy /swap alkötetet hoz létre a rendszerindító meghajtódon, a fizikai RAM méretével megegyező nagyságban, ezért gondoskodj arról, hogy bőven legyen szabad helyed. Egy 32GB-os gépen ehhez a kötethez mindig 32GB+ szabad helyre lesz szükséged. A hibernáláshoz az alapértelmezett Limine rendszerbetöltő is szükséges.

Beállítás után a hibernálás lehetőséget a _Rendszer_ alatt (vagy a `Super + Esc` billentyűkombinációval) látod, ezután pedig megnézheted, következetesen működik-e a rendszereden. Ha nem, az `unbloarchy hibernation remove` parancs futtatásával ismét eltávolíthatod.
