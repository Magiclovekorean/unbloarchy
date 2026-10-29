# Spánok systému

Unbloarchy má predvolene povolené uspanie a hibernáciu, ale ak máte na svojom stroji problémy s niektorou z nich, môžete ich vypnúť.

Na strojoch s NVIDIA GB10, ako sú DGX Spark a ASUS Ascent GX10, sú uspanie a hibernácia vypnuté, rovnako ako v NVIDIA DGX OS, pretože sa zatiaľ nepreukázalo, že spánok na tomto hardvéri funguje. Prepínač uspania a nastavenie hibernácie sa tam neuplatňujú. Ak chcete spánok znova zapnúť, odstráňte `/etc/systemd/sleep.conf.d/unbloarchy-sleep-disabled.conf` pomocou `sudo rm`; možnosť Uspať sa potom vráti do ponuky a hibernáciu možno nastaviť ako na iných strojoch. Spustením `sudo unbloarchy apply hardware --install-user "$USER"` sa súbor vráti späť.

### Profily napájania

Na laptope si Unbloarchy pamätá váš profil napájania osobitne pre napájanie zo siete a pre prevádzku na batériu a prepína medzi nimi, keď ho pripojíte a odpojíte. Predvolene to znamená výkon pri napájaní zo siete a vyvážený režim na batériu.

Čo váš stroj ponúka, zistíte pomocou `unbloarchy powerprofiles list` a ten, ktorý chcete pre stav, v ktorom sa práve nachádzate, nastavíte pomocou `unbloarchy powerprofiles set autodetect power-saver`. Ak chcete nastaviť druhý stav bez toho, aby ste čokoľvek odpájali, pomenujte ho priamo: `unbloarchy powerprofiles set battery power-saver`. Čokoľvek si vyberiete, presne to dostanete späť, keď budete nabudúce v danom stave.

### Prepnutie uspania

Uspatie prepnete spustením `unbloarchy toggle suspend` z terminálu. Tým sa len zobrazí/skryje možnosť v ponuke _Systém_ (alebo `Super + Esc`) a potom môžete zistiť, či na vašom systéme funguje spoľahlivo. Ak nie, rovnakým príkazom ju môžete znova skryť.

### Prepnutie hibernácie

Hibernáciu nastavíte spustením `unbloarchy hibernation setup` z terminálu. Hibernácia vytvorí na vašom zavádzacom disku podzväzok /swap s veľkosťou vašej alokácie fyzickej pamäte RAM, takže sa uistite, že máte dostatok voľného miesta. Na 32GB stroji budete na tento zväzok vždy potrebovať 32GB+ voľného miesta. Hibernácia tiež vyžaduje predvolený zavádzač Limine.

Po nastavení uvidíte možnosť hibernácie v ponuke _Systém_ (alebo `Super + Esc`) a potom môžete zistiť, či na vašom systéme funguje spoľahlivo. Ak nie, môžete ju znova odstrániť spustením `unbloarchy hibernation remove`.
