# Aktualizace

Unbloarchy a vaše balíčky se udržují aktuální přes _Aktualizace > Unbloarchy_ v nabídce Unbloarchy (`Super + Space`).

Samotná Unbloarchy je nainstalovaná jako běžné balíčky pacman z [repozitáře balíčků Unbloarchy](https://github.com/omacom-io/omarchy-pkgs), takže aktualizace nainstaluje [nejnovější vydání Unbloarchy](https://github.com/omacom/omarchy/releases), spustí všechny čekající migrace, aby byl váš systém v souladu s nejnovější verzí, a aktualizuje všechny systémové balíčky z [Arch mirroru Unbloarchy](https://github.com/omacom-io/omarchy-mirror) a [AUR](https://aur.archlinux.org/) (pokud máte nainstalované nějaké balíčky z AUR).

Když vyjdou nová vydání, objeví se vpravo od vašich hodin ikona kruhové šipky. Klikněte na ni a proces aktualizace se spustí.

![update-available](images/update-available.webp)

### Čtyři kanály

Unbloarchy se aktualizuje ve čtyřech kanálech: stable, RC, edge a dev. Nové instalace začínají na kanálu stable, který sleduje [oficiální vydání](https://github.com/omacom/omarchy/releases/) a také [stabilní Arch mirror Unbloarchy](https://github.com/omacom-io/omarchy-mirror), který běží o měsíc pozadu za nejnovějším, abychom mohli zachytit všechny nové nekompatibility vyžadující změny konfigurace dřív, než způsobí lidem problémy.

Pokud ale chcete pomoci tyhle potenciální problémy odhalovat, můžete běžet na kanálu edge. Ten udrží vaše balíčky Unbloarchy na nejnovějších vývojových sestaveních a umožní vám aktualizovat na nejnovější balíčky Arch, jakmile budou k dispozici. Měli byste to dělat jen tehdy, pokud máte zkušenosti s Linuxem a víte, jak obnovit systém, který má problémy.

Před každým novým hlavním vydáním budeme provádět finální ověření pomocí kanálu RC. Pokud máte zájem pomoci s finálním laděním, přijďte si popovídat do #unbloarchy-release-candidates na Discordu.

A konečně je tu kanál dev, který propojí Unbloarchy přímo s git checkoutem zdrojového kódu v `~/unbloarchy` v kombinaci s balíčky edge. Tento kanál byste měli používat jen tehdy, pokud jste zkušený uživatel Linuxu, pracujete přímo na Unbloarchy a jste ochotní tolerovat, že se něco rozbije.

Mezi kanály můžete přepínat pomocí _Aktualizace > Kanál_ v nabídce Unbloarchy (nebo `unbloarchy-channel-set` v terminálu).

### Přepínání kernelů

Unbloarchy bootuje svůj vlastní kernel `linux-omarchy`, ale vedle něj můžete mít nainstalované i další, například výchozí kernel `linux` z Archu nebo experimentální sestavení, které testujete. Když jich máte více než jeden, položka _Aktualizace > Kernel_ v nabídce Unbloarchy je vypíše se zaškrtnutím u toho, který se bootuje ve výchozím nastavení. Vyberte jiný, jednou zadejte své heslo a po příštím restartu nabootuje právě ten. Ostatní kernely zůstanou v bootovací nabídce, takže si jeden stále můžete vybrat ručně, pokud vám nový výchozí dělá potíže. V terminálu zobrazí `unbloarchy-kernel` aktuální výchozí kernel, `unbloarchy-kernel list` to, co je nainstalované, a `unbloarchy-kernel set <kernel>` slouží k přepnutí.

### Aktualizace firmwaru

Vaše balíčky nejsou to jediné, co zastarává. Mnoho laptopů a periferií dodává firmware pro BIOS, SSD a dok prostřednictvím Linux Vendor Firmware Service a položka _Aktualizace > Firmware_ v nabídce Unbloarchy stáhne a nainstaluje vše, co na váš hardware čeká. Při prvním spuštění nainstaluje `fwupd`. Spoustu firmwaru lze zapsat jen během restartu, takže se nedivte, když o něj budete požádáni.

### Varování před přímými aktualizacemi přes pacman/yay

Pokud už Arch znáte, možná vás bude lákat prostě si sami spustit `pacman -Syu` nebo `yay -Syu`, ale pokud to uděláte, přijdete o snímek, migrace a aktualizace konfigurace, které Unbloarchy spouští společně s novými balíčky. Proto Unbloarchy přímou aktualizaci systému ve skutečnosti zastaví a místo toho vás odkáže na `unbloarchy update`. (Pokud opravdu víte, co děláte, ochrana vám řekne, jak ji pro jednu transakci obejít.)

### Vrácení špatných aktualizací

Pokud budete mít někdy po aktualizaci problém, můžete systém vrátit zpět ke snímku pořízenému před aktualizací. Stačí restartovat a v nabídce boot loaderu vybrat snímek z doby před tím, než jste aktualizaci spustili.

![bootloader](images/bootloader.webp)

Pokud se vám nějak poškodí konfigurační soubory, můžete také provést reinstalaci Unbloarchy pomocí `unbloarchy reinstall` v terminálu. Tím se přeinstalují všechny výchozí balíčky Unbloarchy, přepnete se na stable, downgradují se všechny balíčky, které jsou příliš nové, a resetují se všechny konfigurační soubory. Pozor, všechny vaše uživatelské změny výchozí konfigurace Unbloarchy se při tom přepíšou!
