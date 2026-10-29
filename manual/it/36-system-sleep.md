# Sospensione del sistema

Unbloarchy abilita la sospensione e l'ibernazione per impostazione predefinita, ma se riscontri problemi con l'una o l'altra sulla tua macchina, puoi disattivarle.

Sulle macchine NVIDIA GB10, come DGX Spark e ASUS Ascent GX10, la sospensione e l'ibernazione sono disattivate, come in DGX OS di NVIDIA, perché non è ancora stato dimostrato che la sospensione funzioni su quell'hardware. L'attivazione/disattivazione della sospensione e la configurazione dell'ibernazione non si applicano in quel caso. Per riattivare la sospensione, rimuovi `/etc/systemd/sleep.conf.d/unbloarchy-sleep-disabled.conf` con `sudo rm`; Suspend riappare poi nel menu e l'ibernazione può essere configurata come sulle altre macchine. L'esecuzione di `sudo unbloarchy apply hardware --install-user "$USER"` ripristina il file.

### Profili energetici

Su un portatile, Unbloarchy ricorda il tuo profilo energetico separatamente per quando sei collegato alla rete elettrica e quando funziono a batteria, e passa dall'uno all'altro quando colleghi e scolleghi l'alimentatore. Per impostazione predefinita, questo significa prestazioni con alimentazione AC e bilanciato a batteria.

Puoi vedere cosa offre la tua macchina con `unbloarchy powerprofiles list`, e impostare quello che desideri per lo stato in cui ti trovi attualmente con `unbloarchy powerprofiles set autodetect power-saver`. Per impostare l'altro stato senza scollegare nulla, indicalo direttamente: `unbloarchy powerprofiles set battery power-saver`. Qualunque tu scelga, è quello che ritroverai la prossima volta che ti troverai in quello stato.

### Attivare/disattivare la sospensione

Attivi/disattivi la sospensione eseguendo `unbloarchy toggle suspend` dal terminale. Questo mostra/nasconde semplicemente l'opzione in _System_ (o `Super + Esc`), così puoi verificare se funziona in modo affidabile sul tuo sistema. In caso contrario, puoi nasconderla di nuovo con lo stesso comando.

### Attivare/disattivare l'ibernazione

Configuri l'ibernazione eseguendo `unbloarchy hibernation setup` dal terminale. L'ibernazione crea un sottovolume /swap sul tuo disco di avvio con le dimensioni della tua RAM fisica, quindi assicurati di avere spazio in abbondanza. Su una macchina da 32GB, avrai sempre bisogno di oltre 32GB liberi per questo volume. L'ibernazione richiede anche il bootloader Limine predefinito.

Una volta configurata, vedrai l'opzione di ibernazione in _System_ (o `Super + Esc`), così puoi verificare se funziona in modo affidabile sul tuo sistema. In caso contrario, puoi rimuoverla di nuovo eseguendo `unbloarchy hibernation remove`.
