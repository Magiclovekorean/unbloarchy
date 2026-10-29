# Uppfærslur

Unbloarchy og pökkunum þínum er haldið uppfærðum í gegnum _Update > Unbloarchy_ í Unbloarchy-valmyndinni (`Super + Space`).

Unbloarchy sjálft er sett upp sem venjulegir pacman-pakkar frá [pakkageymslu Unbloarchy](https://github.com/omacom-io/omarchy-pkgs), svo uppfærsla setur upp [nýjustu útgáfu Unbloarchy](https://github.com/omacom/omarchy/releases), keyrir allar biðjandi flutninga til að samstilla kerfið þitt við það nýjasta og uppfærir alla kerfispakka frá [Unbloarchy Arch Mirror](https://github.com/omacom-io/omarchy-mirror) og [AUR](https://aur.archlinux.org/) (ef þú hefur sett upp einhverja AUR-pakka).

Þegar nýjar útgáfur koma út birtist tákn með hringör hægra megin við klukkuna þína. Smelltu á það og uppfærsluferlið hefst.

![update-available](images/update-available.webp)

### Fjórar rásir

Unbloarchy er uppfært eftir fjórum rásum: stable, RC, edge og dev. Nýjar uppsetningar byrja á stable-rásinni, sem fylgir [opinberum útgáfum](https://github.com/omacom/omarchy/releases/), sem og [stöðuga Unbloarchy Arch-speglinum](https://github.com/omacom-io/omarchy-mirror) sem er einum mánuði á eftir því nýjasta, svo við getum gripið nýjan ósamrýmanleika sem krefst stillingabreytinga áður en hann veldur fólki vandræðum.

En ef þú vilt hjálpa til við að koma auga á þessi hugsanlegu vandamál geturðu keyrt á edge-rásinni. Þá munu Unbloarchy-pakkarnir þínir fylgja nýjustu þróunarútgáfum og þú getur uppfært í nýjustu Arch-pakkana um leið og þeir verða fáanlegir. Þú ættir aðeins að gera þetta ef þú hefur reynslu af Linux og veist hvernig á að bjarga kerfi sem lendir í vandræðum.

Áður en hver ný stór útgáfa kemur út munum við gera lokaprófanir á RC-rásinni. Ef þú hefur áhuga á að hjálpa til við lokafráganginn skaltu kíkja við í #unbloarchy-release-candidates á Discord.

Að lokum er það dev-rásin, sem tengir Unbloarchy beint við git-afrit af frumkóðanum í `~/unbloarchy`, ásamt edge-pökkunum. Þú ættir aðeins að nota þessa rás ef þú ert reyndur Linux-notandi, vinnur beint að Unbloarchy og ert tilbúinn að þola bilanir.

Þú getur skipt á milli rása með _Update > Channel_ í Unbloarchy-valmyndinni (eða `unbloarchy-channel-set` í skelinni).

### Að skipta um kjarna

Unbloarchy ræsir sinn eigin `linux-omarchy` kjarna, en þú getur haft aðra uppsetta við hliðina á honum, eins og venjulega Arch `linux` kjarnann eða tilraunaútgáfu sem þú ert að prófa. Þegar þeir eru fleiri en einn sýnir _Update > Kernel_ í Unbloarchy-valmyndinni þá með hak við þann sem ræsist sjálfgefið. Veldu annan, sláðu inn lykilorðið þitt einu sinni, og hann mun ræsast eftir næstu endurræsingu. Hinir kjarnarnir verða áfram í ræsivalmyndinni, svo þú getur enn valið einn handvirkt ef nýja sjálfgefna valið veldur þér vandræðum. Í skelinni er það `unbloarchy-kernel` til að sjá núverandi sjálfgefna kjarnann, `unbloarchy-kernel list` fyrir það sem er uppsett og `unbloarchy-kernel set <kernel>` til að skipta.

### Fastbúnaðaruppfærslur

Pakkar eru ekki það eina sem verður úrelt. Margar fartölvur og jaðartæki senda BIOS-, SSD- og tengikvíarfastbúnað í gegnum Linux Vendor Firmware Service, og _Update > Firmware_ í Unbloarchy-valmyndinni sækir og setur upp það sem vélbúnaðurinn þinn á í bið. Það setur upp `fwupd` í fyrsta skipti sem þú keyrir það. Mikið af fastbúnaði er aðeins hægt að skrifa við endurræsingu, svo ekki verða hissa ef þú verður beðinn um eina slíka.

### Viðvörun um beinar pacman/yay uppfærslur

Ef þú þekkir Arch nú þegar gætirðu freistast til að keyra bara `pacman -Syu` eða `yay -Syu` sjálfur, en ef þú gerir það missirðu af skyndimyndinni, flutningunum og stillingauppfærslunum sem Unbloarchy keyrir ásamt nýjum pökkum. Þess vegna mun Unbloarchy í raun stöðva beina kerfisuppfærslu og beina þér í `unbloarchy update` í staðinn. (Ef þú virkilega veist hvað þú ert að gera mun vörðurinn segja þér hvernig á að komast framhjá honum fyrir eina færslu.)

### Að afturkalla slæmar uppfærslur

Ef þú lendir einhvern tímann í vandræðum eftir að hafa uppfært geturðu fært kerfið þitt aftur í skyndimyndina sem tekin var fyrir uppfærsluna. Endurræstu bara og veldu skyndimyndina í ræsivalmyndinni frá því áður en þú byrjaðir uppfærsluna.

![bootloader](images/bootloader.webp)

Ef stillingarskrárnar þínar hafa einhvern veginn skemmst geturðu líka endursett Unbloarchy með `unbloarchy reinstall` í skelinni. Það mun endursetja alla sjálfgefna Unbloarchy-pakkana, setja þig á stable og lækka útgáfu allra pakka sem eru of nýir, og endurstilla allar stillingarskrárnar. Athugaðu að allar breytingar þínar á sjálfgefnum stillingum Unbloarchy verða yfirskrifaðar ef þú gerir þetta!
