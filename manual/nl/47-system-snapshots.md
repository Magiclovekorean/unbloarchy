# Systeemsnapshots

We maken automatisch snapshots bij elke Unbloarchy-update, maar als je er zelf een wilt maken, kun je `unbloarchy-snapshot create` gebruiken.

Om een snapshot op te starten en te herstellen, selecteer je deze in de Limine-bootloader. (Als je momenteel rechtstreeks naar het Unbloarchy-ontsleutelingsscherm opstart, moet je eerst Limine als opstartoptie selecteren via de BIOS).

Kies vanaf dat scherm de snapshot waarnaar je wilt opstarten op basis van de datum en versie. De versie van Unbloarchy op het moment van de snapshot is linksonder in de hoek te zien.

 ![snapshots-bootloader](images/snapshots-bootloader.webp)

Wanneer je binnen bent, verschijnt er een melding dat je in een opstartbare snapshot zit en als je erop klikt, start het herstelproces. Je kunt ook `unbloarchy-snapshot restore` gebruiken.

 ![snapshots-restore](images/snapshots-restore.webp)

Dit herstelt je rootbestandssysteem, maar niet je `/home`. Dus het werkt om een kapotte systeemupdate terug te draaien, maar niet om verloren persoonlijke bestanden te herstellen.

Dit betekent ook dat je `~/.config`-map ongewijzigd blijft. Dus als je teruggaat naar een eerdere versie van een bibliotheek of applicatie die configuratiebestanden in een nieuw formaat opslaat, moet je dat handmatig oplossen.

Hetzelfde geldt voor Unbloarchy's eigen registratie van welke migraties al zijn uitgevoerd: deze staat in je thuismap, dus deze overleeft het herstel. Migraties die zijn uitgevoerd nadat de snapshot is gemaakt, blijven gemarkeerd als voltooid, ook al zijn de wijzigingen die ze in het rootbestandssysteem hebben aangebracht teruggedraaid, en de volgende `unbloarchy update` voert ze niet opnieuw uit. Dus als je na een herstel opnieuw update en iets wat een eerdere update had ingesteld nog steeds ontbreekt, is dat waarschijnlijk de reden.

_Let op: Deze functie is alleen beschikbaar op installaties die de Limine-bootloader gebruiken, wat sinds Unbloarchy 2.0 de standaard is. Het is niet beschikbaar als je GRUB of systemd-boot gebruikt._

### Het opstartmenu overslaan

Als je het opstartmenu nooit aanraakt en gewoon wilt dat de machine rechtstreeks naar het ontsleutelingsscherm gaat, voer dan _Setup > Direct Boot_ uit in het Unbloarchy-menu. Dat voegt een EFI-item toe dat rechtstreeks naar Unbloarchy wijst, zodat de firmware deze opstart zonder bij Limine te stoppen.

De afweging is degene die bovenaan is genoemd: met direct boot ingeschakeld betekent bij een snapshot komen dat je eerst Limine moet kiezen uit je BIOS-opstartmenu. Voer _Setup > Direct Boot_ opnieuw uit om het item te verwijderen en weer via Limine op te starten. Sommige firmware kan niet goed overweg met aangepaste EFI-items, dus de setup weigert te draaien op American Megatrends- en Apple-firmware.
