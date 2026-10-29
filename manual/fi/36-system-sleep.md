# Järjestelmän lepotila

Unbloarchy ottaa valmiustilan ja horrostilan käyttöön oletuksena, mutta jos sinulla on ongelmia kumman tahansa kanssa koneellasi, voit kytkeä ne pois päältä.

NVIDIA GB10 -koneilla, kuten DGX Spark ja ASUS Ascent GX10, valmiustila ja horrostila on kytketty pois päältä, kuten NVIDIA:n DGX OS:ssäkin, koska lepotilan ei ole vielä osoitettu toimivan kyseisellä laitteistolla. Valmiustilan kytkin ja horrostilan määritys eivät koske niitä. Saadaksesi lepotilan takaisin käyttöön poista `/etc/systemd/sleep.conf.d/unbloarchy-sleep-disabled.conf` komennolla `sudo rm`; valmiustila palaa sitten valikkoon, ja horrostila voidaan määrittää kuten muillakin koneilla. Komennon `sudo unbloarchy apply hardware --install-user "$USER"` suorittaminen palauttaa tiedoston.

### Virtaprofiiilit

Kannettavalla tietokoneella Unbloarchy muistaa virtaprofiiilisi erikseen verkkovirtaan kytkettynä ja akulla käytettäessä ja vaihtaa näiden kahden välillä, kun kytket laturin tai irrotat sen. Oletuksena tämä tarkoittaa suorituskykyä verkkovirralla ja tasapainotettua akulla.

Näet koneesi tarjoamat vaihtoehdot komennolla `unbloarchy powerprofiles list`, ja asetat haluamasi parhaillaan käyttämällesi tilalle komennolla `unbloarchy powerprofiles set autodetect power-saver`. Asettaaksesi toisen tilan irrottamatta mitään, nimeä se suoraan: `unbloarchy powerprofiles set battery power-saver`. Valitsemasi vaihtoehto on se, jonka saat takaisin seuraavan kerran, kun olet kyseisessä tilassa.

### Valmiustilan kytkeminen

Kytket valmiustilan suorittamalla `unbloarchy toggle suspend` terminaalista. Se vain näyttää/piilottaa vaihtoehdon kohdassa _System_ (tai `Super + Esc`), ja sitten voit katsoa, toimiiko se johdonmukaisesti järjestelmässäsi. Jos ei, voit piilottaa sen uudelleen samalla komennolla.

### Horrostilan kytkeminen

Määrität horrostilan suorittamalla `unbloarchy hibernation setup` terminaalista. Horrostila luo /swap-alivolyymin käynnistysasemallesi, jonka koko vastaa fyysisen RAM-muistisi määrää, joten varmista, että sinulla on runsaasti tilaa vapaana. 32GB:n koneella tarvitset aina 32GB+ vapaata tilaa tälle volyymille. Horrostila vaatii myös oletusarvoisen Limine-käynnistyslataimen.

Kun se on määritetty, näet horrostilavaihtoehdon kohdassa _System_ (tai `Super + Esc`), ja sitten voit katsoa, toimiiko se johdonmukaisesti järjestelmässäsi. Jos ei, voit poistaa sen uudelleen suorittamalla `unbloarchy hibernation remove`.
