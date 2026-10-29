# Aktualizácie

Unbloarchy a vaše balíky sa udržiavajú aktuálne cez _Aktualizácia > Unbloarchy_ v ponuke Unbloarchy (`Super + Space`).

Unbloarchy samotná je nainštalovaná ako bežné balíky pacman z [úložiska balíkov Unbloarchy](https://github.com/omacom-io/omarchy-pkgs), takže aktualizácia nainštaluje [najnovšie vydanie Unbloarchy](https://github.com/omacom/omarchy/releases), spustí všetky čakajúce migrácie, aby váš systém zosúladila s najnovšou verziou, a aktualizuje všetky systémové balíky z [mirroru Unbloarchy Arch](https://github.com/omacom-io/omarchy-mirror) a [AUR](https://aur.archlinux.org/) (ak máte nainštalované nejaké balíky AUR).

Keď vyjdú nové vydania, napravo od vašich hodín sa zobrazí ikona kruhovej šípky. Kliknite na ňu a proces aktualizácie sa spustí.

![update-available](images/update-available.webp)

### Štyri kanály

Unbloarchy sa aktualizuje v štyroch kanáloch: stable, RC, edge a dev. Nové inštalácie začínajú na kanáli stable, ktorý sleduje [oficiálne vydania](https://github.com/omacom/omarchy/releases/), ako aj [stabilný mirror Unbloarchy Arch](https://github.com/omacom-io/omarchy-mirror), ktorý beží o jeden mesiac pozadu za najnovším, aby sme stihli zachytiť všetky nové nekompatibility, ktoré si vyžadujú zmeny konfigurácie, skôr než spôsobia ľuďom problémy.

Ale ak chcete pomôcť odhaľovať tieto potenciálne problémy, môžete bežať na kanáli edge. Ten udrží vaše balíky Unbloarchy na najnovších vývojových zostaveniach a umožní vám aktualizovať na najnovšie balíky Arch, hneď ako budú k dispozícii. Mali by ste to robiť len vtedy, ak máte skúsenosti s Linuxom a viete, ako obnoviť systém, ktorý má problémy.

Pred každým novým hlavným vydaním budeme robiť finálnu validáciu pomocou kanála RC. Ak máte záujem pomôcť s finálnym ladením, príďte sa porozprávať do #unbloarchy-release-candidates na Discorde.

Napokon je tu kanál dev, ktorý prepája Unbloarchy priamo s git checkoutom zdrojového kódu v `~/unbloarchy`, skombinovaným s balíkmi edge. Tento kanál by ste mali používať len vtedy, ak ste skúsený používateľ Linuxu, pracujete priamo na Unbloarchy a ste ochotní tolerovať rozbitie.

Medzi kanálmi môžete prepínať pomocou _Aktualizácia > Kanál_ z ponuky Unbloarchy (alebo `unbloarchy-channel-set` v termináli).

### Prepínanie jadier

Unbloarchy zavádza vlastné jadro `linux-omarchy`, ale vedľa neho môžete mať nainštalované aj iné, napríklad štandardné jadro Arch `linux` alebo experimentálne zostavenie, ktoré testujete. Keď ich je viac ako jedno, _Aktualizácia > Jadro_ v ponuke Unbloarchy ich zobrazí so značkou začiarknutia vedľa toho, ktoré sa zavádza predvolene. Vyberte iné, raz zadajte heslo a po ďalšom reštarte sa zavedie. Ostatné jadrá zostanú v zavádzacej ponuke, takže si jedno stále môžete vybrať ručne, ak vám nové predvolené spôsobí problémy. V termináli slúži `unbloarchy-kernel` na zobrazenie aktuálneho predvoleného, `unbloarchy-kernel list` na to, čo je nainštalované, a `unbloarchy-kernel set <kernel>` na prepnutie.

### Aktualizácie firmvéru

Nie sú to len vaše balíky, čo zastaráva. Mnoho notebookov a periférií dodáva firmvér BIOS, SSD a doku cez Linux Vendor Firmware Service a _Aktualizácia > Firmvér_ v ponuke Unbloarchy stiahne a nainštaluje všetko, čo má váš hardvér pripravené. Pri prvom spustení nainštaluje `fwupd`. Množstvo firmvéru možno zapísať len počas reštartu, takže sa nečudujte, ak vás oň požiada.

### Varovanie pred priamymi aktualizáciami pacman/yay

Ak už Arch poznáte, možno vás bude lákať jednoducho spustiť `pacman -Syu` alebo `yay -Syu` sami, ale ak to urobíte, prídete o snímku, migrácie a aktualizácie konfigurácie, ktoré Unbloarchy spúšťa spolu s novými balíkmi. Preto Unbloarchy priamu aktualizáciu systému skutočne zastaví a namiesto toho vás nasmeruje na `unbloarchy update`. (Ak naozaj viete, čo robíte, ochrana vám povie, ako ju pre jednu transakciu obísť.)

### Vrátenie zlých aktualizácií

Ak budete mať po vykonaní aktualizácie niekedy problém, môžete systém vrátiť späť na snímku vytvorenú pred aktualizáciou. Stačí reštartovať a v ponuke zavádzania vybrať snímku spred spustenia aktualizácie.

![bootloader](images/bootloader.webp)

Ak sa vaše konfiguračné súbory nejako poškodili, môžete tiež vykonať opätovnú inštaláciu Unbloarchy pomocou `unbloarchy reinstall` v termináli. Tá preinštaluje všetky predvolené balíky Unbloarchy, prepne vás na stable a zníži verziu všetkých balíkov, ktoré sú príliš nové, a obnoví všetky konfiguračné súbory. Upozorňujeme, že týmto prepíšete všetky svoje používateľské zmeny konfigurácie oproti predvoleným nastaveniam Unbloarchy!
