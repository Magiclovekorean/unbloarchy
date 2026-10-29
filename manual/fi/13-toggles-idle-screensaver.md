# Vipukytkimet, joutotila ja näytönsäästäjä

Suuri osa siitä, mitä muutat päivittäin, ei oikeastaan ole asetus. Se on tila, jonka kytket päälle tunniksi ja sitten taas pois: yövalo, kun työskentelet myöhään, älä häiritse, kun esität, pysy hereillä, kun katsot jotain. Unbloarchy kutsuu niitä vipukytkimiksi, ja ne kaikki toimivat samalla tavalla — pikanäppäin, valikon kohta ja komento osuvat kaikki samaan kytkimeen.

### Vipukytkinvalikko

`Super + Ctrl + O` avaa _Trigger > Toggle_ -valikon suoraan, tai sinne pääsee Unbloarchy-valikon kautta (`Super + Space`). Kaikki tuossa luettelossa ovat kytkimiä, joita voit napsauttaa sen kummemmin miettimättä, missä tila säilyy. Työpöydän ulkoasua koskevat kytkimet ovat sen vieressä _Appearance_-kohdan alla.

Päätteessä samat kytkimet ovat `unbloarchy toggle <thing>`. Aja `unbloarchy toggle` yksinään nähdäksesi koko ryhmän.

| Vipukytkin | Pikanäppäin | Komento |
| ------ | ------ | ------- |
| Yövalo | — | `unbloarchy toggle nightlight` |
| Hiljennä ilmoitukset | `Super + Ctrl + Alt + ,` | `unbloarchy toggle notification silencing` |
| Pysy hereillä (ei joutolukitusta) | `Super + Ctrl + I` | `unbloarchy toggle idle` |
| Kaatumisten tallennus | — | `unbloarchy toggle crash-capture` |
| Näytönsäästäjä | — | `unbloarchy toggle screensaver` |
| [Herdr](https://herdr.dev) -teeman synkronointi | — | `unbloarchy toggle theme sync` |
| Valikkopalkki | `Super + Shift + Space` | `unbloarchy toggle bar` |
| Kosketuslevy | `XF86TouchpadToggle` | `unbloarchy toggle touchpad` |
| Kosketusnäyttö | — | `unbloarchy toggle touchscreen` |
| Valmiustila | — | `unbloarchy toggle suspend` |
| Hybridi-GPU | — | `unbloarchy toggle hybrid gpu` |

Kosketuslevyn, kosketusnäytön ja hybridi-GPU:n kytkimet ovat _Trigger > Hardware_ -kohdan alla (`Super + Ctrl + H`) Toggle-kohdan sijaan, koska ne näkyvät vain, jos sinulla todella on kyseinen laitteisto. Kosketuslevyn ja kosketusnäytön kytkimet säilyvät Hyprlandin uudelleenlatauksen yli — käytöstä poistetun laitteen nimi tallennetaan pieneen tilatiedostoon, jonka Hyprland lukee käynnistyksessä poistaakseen sen uudelleen käytöstä.

_Appearance_-kohdassa ovat valikkopalkki ja animaatiot sekä muutama asia, jotka eivät ole `unbloarchy toggle` -komentoja mutta toimivat samalla tavalla: akun prosentti palkissa, työtilojen oletusasettelu ja _Windows_-kohdan alla ikkunoiden välit (`Super + Shift + Backspace`) ja yhden ikkunan neliönmuotoinen kuvasuhde (`Super + Ctrl + Backspace`).

Useimmat näistä ovat vain lipputiedosto kansiossa `~/.local/state/unbloarchy/toggles/`. Jos haluat haarautua jonkin perusteella skriptissä, `unbloarchy-toggle-enabled` antaa sinulle poistumiskoodin sen sijaan, että joutuisit etsimään sitä itse:

```bash
unbloarchy-toggle-enabled screensaver-off && echo "screensaver is off"
```

Liput on nimetty pois päältä -tilan mukaan — `screensaver-off`, `suspend-off`, `bar-off` — joten niiden olemassaolo tarkoittaa, että ominaisuus on pois käytöstä.

### Ilmaisimet palkissa

Kun jokin tila on päällä, yläpalkin keskelle kellon viereen ilmestyy pieni kuvake. Se on ilmaisimien widget, ja siinä näkyvät sanelu, näytön tallennus, odottavat muistutukset, yövalo, älä häiritse ja pysy hereillä.

Ei-aktiiviset ilmaisimet ovat piilossa. Vie osoitin mihin tahansa palkin kohtaan, niin ne häivytetään näkyviin himmennettyinä, joten voit napsauttaa yhden päälle tuntematta sen pikanäppäintä. Aktiivisen napsauttaminen kytkee sen takaisin pois. Jos haluat mieluummin nähdä ne kaikki koko ajan, aseta `alwaysShow` arvoon `true` kohdassa `unbloarchy.indicators` tiedostossa `~/.config/unbloarchy/shell.json` — katso [yläpalkista](05-the-top-bar.md), miten palkin widgetit määritetään.

### Yövalo

Yövalo lämmittää näytön 4000K:hon, ja sen kytkeminen uudelleen palauttaa sen 6500K:hon. Kytke se vipukytkinvalikosta (`Super + Ctrl + O`) tai komennolla `unbloarchy toggle nightlight`. Sitä ajaa hyprsunset, jonka kytkin käynnistää puolestasi, jos se ei ole jo käynnissä.

Oletuksena hyprsunset ei tee näytöllesi yhtään mitään. Tiedostossa `~/.config/hypr/hyprsunset.conf` on valmiina identiteettiprofiili juuri siksi, että näyttö pysyy koskemattomana, kunnes pyydät lämpöä. Jos haluat mieluummin sen vaihtuvan kellon mukaan, korvaa se aikaprofiililla:

```
profile {
    time = 20:00
    temperature = 4000
}
```

Käynnistä sitten hyprsunset sisäänkirjautumisen yhteydessä lisäämällä `o.launch_on_start("hyprsunset")` tiedostoon `~/.config/hypr/autostart.lua`. Kytkimen käyttämä 4000K/6500K-pari on kiinteä, joten määritystiedosto on paikka, johon menet, jos haluat eri lämpötilan.

### Älä häiritse

`Super + Ctrl + Alt + ,` hiljentää ilmoitukset. Mitään ponnahdusilmoituksia ei ilmesty sen ollessa päällä, ja yliviivattu kelloilmaisin istuu palkissa muistuttamassa, miksi työpöytä on hiljentynyt.

Mitään ei kuitenkaan menetetä. Hiljennetyt ilmoitukset pidetään tallessa: tuo viimeisimmät takaisin näytölle näppäimillä `Super + Shift + Alt + ,`. Katso loput kohdasta [ilmoitukset](10-notices.md).

Kahdenlaiset viestit pääsevät silti läpi: Unbloarchyn omat vahvistusilmoitukset jostain, mitä juuri teit ("Theme changed", "Screenshot saved"), ja komentoriviltä lähetetyt kriittiset hälytykset. Keskustelusovellukset, jotka merkitsevät kaiken kriittiseksi pakottaakseen itsensä eteesi, eivät kelpaa.

### Joutotila

Unbloarchyn kuori omistaa joutokäyttäytymisen, ja ajoitukset ovat ylätason `idle`-lohko tiedostossa `~/.config/unbloarchy/shell.json`:

```json
{
  "version": 1,
  "idle": {
    "screensaver": 150,
    "lock": 300
  }
}
```

Molemmat luvut ovat sekunteja, jotka lasketaan siitä hetkestä, kun siirryit joutotilaan — ei toisistaan. Oletuksilla näytönsäästäjä tulee siis esiin kahden ja puolen minuutin kuluttua ja lukitusnäyttö ottaa vallan viiden minuutin kohdalla riippumatta siitä, käynnistyikö näytönsäästäjä. Tallenna tiedosto, niin kuori ottaa uudet ajoitukset käyttöön heti.

Jos hylkäät näytönsäästäjän ennen lukituksen määräaikaa, se lasketaan toiminnaksi ja odottava lukitus peruutetaan. Et jää lukituksi ulos siitä, että vilkaisit konettasi.

Jos haluat lopettaa joutolukituksen kokonaan, `Super + Ctrl + I` — tai `unbloarchy toggle idle` — kytkee pysy hereillä -tilan päälle, ja kahvikupin ilmaisin ilmestyy palkkiin. Se on se, jota painat ennen pitkää esitystä tai käännöstä, jota haluat seurata. Paina sitä uudelleen palataksesi normaaliin. `unbloarchy toggle idle status` tulostaa nykyisen tilan JSON-muodossa, jos tarvitset sitä skriptistä.

Tässä on kyse lukituksesta ja näytönsäästäjästä, ei virrasta. Valmiustilalla ja horrostilalla on oma määrityksensä kohdassa [järjestelmän lepotila](36-system-sleep.md).

### Näytönsäästäjä

Unbloarchyn näytönsäästäjä on ASCII-taidetta, joka käy läpi satunnaisia tekstitehosteita, yksi esiintymä näyttöä kohti. Mikä tahansa näppäimenpainallus tai hiiren liike lopettaa sen.

Voit käynnistää sen tarvittaessa kohdasta _System > Screensaver_ (`Super + Esc`), mikä pakottaa sen esiin, vaikka olisit kytkenyt joutotilan näytönsäästäjän pois. Sille ei ole oletuksena sidottu pikanäppäintä.

`unbloarchy toggle screensaver` kytkee joutotilan näytönsäästäjän pois, jos haluat mieluummin siirtyä suoraan työskentelystä lukittuun tilaan. Mikä tahansa näppäin, napsautus, vieritys tai hiiren liike sulkee sen.

Sen piirtämä logo on sinun muutettavissasi kohdassa _Appearance > Branding > Screensaver_. Lataa png tai svg, niin Unbloarchy muuntaa sen ASCII-muotoon. Katso [brändäys](41-branding.md).

### Lukitusnäyttö

`Super + Ctrl + L` lukitsee koneen. Se ajaa Unbloarchyn kuoren lukitusnäytön, sammuttaa näytön, palauttaa näppäimistöasettelusi ensimmäiseen, jotta et kirjoita salasanaasi väärillä aakkosilla, ja — jos se on käynnissä — lukitsee 1Passwordin poistuessaan.

Lukitusnäyttö ottaa salasanan, ja se ottaa myös sormenjäljen, kun olet määrittänyt sellaisen. Se ja muut tunnistautumistavat käsitellään kohdassa [laitteistotunnistautuminen](37-hardware-authentication.md).
