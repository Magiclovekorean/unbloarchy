# Kerfisskyndimyndir

Við búum til skyndimyndir sjálfkrafa við hverja Unbloarchy uppfærslu, en ef þú vilt búa til þína eigin geturðu notað `unbloarchy-snapshot create`.

Til að ræsa og endurheimta skyndimynd velur þú hana í Limine boot loader. (Ef þú ræsir núna beint inn í Unbloarchy afkóðunarskjáinn þarftu fyrst að velja Limine sem ræsimöguleika í gegnum BIOS).

Á þeim skjá velur þú skyndimyndina sem þú vilt ræsa í, eftir dagsetningu og útgáfu. Útgáfu Unbloarchy á þeim tíma sem skyndimyndin var tekin má sjá neðst í vinstra horninu.

 ![snapshots-bootloader](images/snapshots-bootloader.webp)

Þegar þú kemur inn birtist tilkynning sem lætur þig vita að þú sért í ræsanlegri skyndimynd og ef þú smellir á hana hefst endurheimtarferlið. Annars geturðu notað `unbloarchy-snapshot restore`.

 ![snapshots-restore](images/snapshots-restore.webp)

Þetta endurheimtir rótarskráarkerfið þitt, en ekki `/home`. Það virkar því til að bakfæra bilaða kerfisuppfærslu, en ekki til að endurheimta týnd persónuleg skjöl.

Þetta þýðir líka að `~/.config` skráarsafnið þitt helst óbreytt. Ef þú bakfærir í eldri útgáfu af safni eða forriti sem geymir stillingarskrár á nýju sniði þarftu því að laga það handvirkt.

Sama gildir um eigin skrá Unbloarchy yfir hvaða flutningar hafa þegar keyrt: hún býr í heimaskráarsafninu þínu, svo hún lifir endurheimtina af. Flutningar sem keyrðu eftir að skyndimyndin var tekin haldast merktir sem kláraðir, jafnvel þótt breytingunum sem þeir gerðu á rótarskráarkerfinu hafi verið bakfært, og næsta `unbloarchy update` keyrir þá ekki aftur. Ef þú uppfærir aftur eftir endurheimt og eitthvað sem fyrri uppfærsla hafði sett upp vantar enn, er það líklega ástæðan.

_Athugið: Þessi eiginleiki er aðeins í boði á uppsetningum sem nota Limine boot loader, sem hefur verið sjálfgefið síðan Unbloarchy 2.0. Hann er ekki í boði ef þú ert á GRUB eða systemd-boot._

### Að sleppa ræsivalmyndinni

Ef þú snertir aldrei ræsivalmyndina og vilt bara að vélin fari beint á afkóðunarskjáinn skaltu keyra _Setup > Direct Boot_ í Unbloarchy valmyndinni. Það bætir við EFI færslu sem bendir beint á Unbloarchy, svo fastbúnaðurinn ræsir það án þess að stoppa í Limine.

Málamiðlunin er sú sem nefnd var efst: með beina ræsingu virka þýðir það að komast í skyndimynd að þú þarft fyrst að velja Limine í BIOS ræsivalmyndinni þinni. Keyrðu _Setup > Direct Boot_ aftur til að fjarlægja færsluna og fara aftur í að ræsa í gegnum Limine. Sumum fastbúnaði líkar illa við sérsniðnar EFI færslur, svo uppsetningin neitar að keyra á American Megatrends og Apple fastbúnaði.
