# Spavanje sustava

Unbloarchy prema zadanim postavkama omogućuje suspendiranje i hibernaciju, ali ako na svom računalu imate problema s bilo čime od toga, možete ih isključiti.

Na računalima s NVIDIA GB10, kao što su DGX Spark i ASUS Ascent GX10, suspendiranje i hibernacija isključeni su, kao i u NVIDIA-inom DGX OS-u, jer još nije pokazano da spavanje radi na tom hardveru. Prekidač za suspendiranje i postavljanje hibernacije tamo se ne primjenjuju. Da biste ponovno uključili spavanje, uklonite `/etc/systemd/sleep.conf.d/unbloarchy-sleep-disabled.conf` pomoću `sudo rm`; Suspend se zatim vraća u izbornik, a hibernacija se može postaviti kao na drugim računalima. Pokretanje `sudo unbloarchy apply hardware --install-user "$USER"` vraća datoteku.

### Profili napajanja

Na prijenosnom računalu Unbloarchy pamti vaš profil napajanja odvojeno za priključeno napajanje i za rad na bateriji te se prebacuje između njih dok priključujete i isključujete napajanje. Iz kutije to znači performanse na AC i uravnoteženo na bateriji.

Možete vidjeti što vaše računalo nudi pomoću `unbloarchy powerprofiles list`, a onaj koji želite za stanje u kojem se trenutno nalazite postaviti pomoću `unbloarchy powerprofiles set autodetect power-saver`. Da biste postavili drugo stanje bez isključivanja ičega, imenujte ga izravno: `unbloarchy powerprofiles set battery power-saver`. Što god odaberete, to ćete dobiti sljedeći put kada budete u tom stanju.

### Prebacivanje suspendiranja

Suspendiranje prebacujete pokretanjem `unbloarchy toggle suspend` iz terminala. Time se samo otkriva/sakriva opcija pod _System_ (ili `Super + Esc`), a zatim možete vidjeti radi li dosljedno na vašem sustavu. Ako ne radi, možete je ponovno sakriti istom naredbom.

### Prebacivanje hibernacije

Hibernaciju postavljate pokretanjem `unbloarchy hibernation setup` iz terminala. Hibernacija stvara /swap podvolumen na vašem pogonu za pokretanje veličine vaše fizičke RAM memorije, pa provjerite imate li dovoljno slobodnog prostora. Na računalu s 32GB uvijek će vam trebati 32GB+ slobodno za ovaj volumen. Hibernacija također zahtijeva zadani Limine bootloader.

Kada je postavljena, vidjet ćete opciju hibernacije pod _System_ (ili `Super + Esc`), a zatim možete vidjeti radi li dosljedno na vašem sustavu. Ako ne radi, možete je ponovno ukloniti pokretanjem `unbloarchy hibernation remove`.
