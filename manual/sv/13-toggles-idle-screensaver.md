# Växlar, inaktivitet & skärmsläckaren

En stor del av det du ändrar till vardags är egentligen inte en inställning. Det är ett läge du slår på i en timme och sedan slår av igen: nattljus medan du jobbar sent, stör ej medan du presenterar, håll vaken medan du tittar på något. Unbloarchy kallar dem växlar, och de fungerar alla på samma sätt — en snabbtangent, en menypost och ett kommando, som alla träffar samma brytare.

### Växelmenyn

`Super + Ctrl + O` öppnar _Trigger > Toggle_ direkt, eller så kan du gå dit från Unbloarchy-menyn (`Super + Space`). Allt i den listan är en växel du kan slå om utan att fundera över var tillståndet bor. Växlar för hur skrivbordet ser ut sitter bredvid den, under _Appearance_.

Från terminalen är samma växlar `unbloarchy toggle <thing>`. Kör `unbloarchy toggle` på egen hand för att se hela gruppen.

| Växel | Snabbtangent | Kommando |
| ------ | ------ | ------- |
| Nattljus | — | `unbloarchy toggle nightlight` |
| Tysta aviseringar | `Super + Ctrl + Alt + ,` | `unbloarchy toggle notification silencing` |
| Håll vaken (ingen låsning vid inaktivitet) | `Super + Ctrl + I` | `unbloarchy toggle idle` |
| Kraschinsamling | — | `unbloarchy toggle crash-capture` |
| Skärmsläckare | — | `unbloarchy toggle screensaver` |
| [Herdr](https://herdr.dev)-temasynk | — | `unbloarchy toggle theme sync` |
| Menyrad | `Super + Shift + Space` | `unbloarchy toggle bar` |
| Styrplatta | `XF86TouchpadToggle` | `unbloarchy toggle touchpad` |
| Pekskärm | — | `unbloarchy toggle touchscreen` |
| Viloläge | — | `unbloarchy toggle suspend` |
| Hybrid GPU | — | `unbloarchy toggle hybrid gpu` |

Växlarna för styrplatta, pekskärm och Hybrid GPU bor under _Trigger > Hardware_ (`Super + Ctrl + H`) snarare än under Toggle, eftersom de bara dyker upp när du faktiskt har den hårdvaran. Växlarna för styrplatta och pekskärm överlever en omladdning av Hyprland — den inaktiverade enhetens namn sparas till en liten tillståndsfil som Hyprland läser vid start för att inaktivera den igen.

_Appearance_ innehåller menyraden och animationer, plus några saker som inte är `unbloarchy toggle`-kommandon men beter sig likadant: batteriprocent i raden, standardlayouten för arbetsytor, och under _Windows_, fönstergap (`Super + Shift + Backspace`) och det kvadratiska bildförhållandet för 1 fönster (`Super + Ctrl + Backspace`).

De flesta av dessa är bara en flaggfil under `~/.local/state/unbloarchy/toggles/`. Om du vill grena på en i ett skript ger `unbloarchy-toggle-enabled` dig en slutkod i stället för att tvinga dig att leta:

```bash
unbloarchy-toggle-enabled screensaver-off && echo "screensaver is off"
```

Flaggorna är namngivna efter det avstängda läget — `screensaver-off`, `suspend-off`, `bar-off` — så deras närvaro betyder att funktionen är inaktiverad.

### Indikatorer i raden

När ett läge är på får du en liten glyf i mitten av den övre raden bredvid klockan. Det är indikatorwidgeten, och den bär diktering, skärminspelning, väntande påminnelser, nattljus, stör ej och håll vaken.

Inaktiva indikatorer är dolda. Håll musen var som helst över raden så tonar de in nedtonade, så att du kan klicka på en för att slå på den utan att kunna dess snabbtangent. Om du klickar på en aktiv indikator stängs den av igen. Om du hellre vill se alla hela tiden sätter du `alwaysShow` till `true` på posten `unbloarchy.indicators` i `~/.config/unbloarchy/shell.json` — se [den övre raden](05-the-top-bar.md) för hur widgetar i raden konfigureras.

### Nattljus

Nattljus värmer skärmen till 4000K, och om du växlar igen sätts den tillbaka till 6500K. Slå om den från växelmenyn (`Super + Ctrl + O`) eller med `unbloarchy toggle nightlight`. Den drivs av hyprsunset, som växeln startar åt dig om den inte redan körs.

Som standard gör hyprsunset ingenting alls med din skärm. `~/.config/hypr/hyprsunset.conf` levereras med en identitetsprofil just för att skärmen ska förbli orörd tills du ber om värme. Om du hellre vill att den växlar efter klockan ersätter du den med en tidsprofil:

```
profile {
    time = 20:00
    temperature = 4000
}
```

Starta sedan hyprsunset vid inloggning genom att lägga till `o.launch_on_start("hyprsunset")` i `~/.config/hypr/autostart.lua`. Paret 4000K/6500K som växeln använder är fast, så konfigurationsfilen är dit du går om du vill ha en annan temperatur.

### Stör ej

`Super + Ctrl + Alt + ,` tystar aviseringar. Inga popup-aviseringar dyker upp medan det är på, och indikatorn med den överkryssade klockan sitter i raden för att påminna dig om varför skrivbordet har blivit tyst.

Inget går förlorat, dock. Tystade aviseringar hålls tillbaka: sätt de senaste tillbaka på skärmen med `Super + Shift + Alt + ,`. Se [aviseringar](10-notices.md) för resten.

Två sorters meddelanden slipper fortfarande igenom: Unbloarchys egna bekräftelseaviseringar för något du just gjorde ("Theme changed", "Screenshot saved"), och kritiska varningar som skickas från kommandoraden. Chattappar som markerar allt som kritiskt för att tvinga sig in framför dig kvalificerar inte.

### Inaktivitet

Unbloarchy-skalet äger inaktivitetsbeteendet, och tiderna är ett `idle`-block på toppnivå i `~/.config/unbloarchy/shell.json`:

```json
{
  "version": 1,
  "idle": {
    "screensaver": 150,
    "lock": 300
  }
}
```

Båda talen är sekunder räknade från ögonblicket du blev inaktiv — inte från varandra. Så med standardvärdena dyker skärmsläckaren upp efter två och en halv minut och låsskärmen tar över vid fem minuter, oavsett om skärmsläckaren kördes eller inte. Spara filen så plockar skalet upp de nya tiderna direkt.

Om du avfärdar skärmsläckaren före låsdeadlinen räknas det som aktivitet och den väntande låsningen avbryts. Du blir inte utelåst för att du kastar en blick på din maskin.

För att sluta låsa vid inaktivitet helt och hållet slår `Super + Ctrl + I` — eller `unbloarchy toggle idle` — på håll vaken, och kaffekoppsindikatorn dyker upp i raden. Det är den du ska trycka på före en lång presentation eller ett bygge du vill titta på. Tryck på den igen för att gå tillbaka till normalt. `unbloarchy toggle idle status` skriver ut det aktuella tillståndet som JSON om du behöver det från ett skript.

Det här handlar om låsning och skärmsläckaren, inte ström. Viloläge och hibernering har sin egen konfiguration i [systemvila](36-system-sleep.md).

### Skärmsläckaren

Unbloarchys skärmsläckare är ASCII-konst som körs genom slumpmässiga texteffekter, en instans per bildskärm. Vilken tangent som helst eller musrörelse avslutar den.

Du kan starta den på begäran från _System > Screensaver_ (`Super + Esc`), vilket tvingar upp den även om du har stängt av skärmsläckaren vid inaktivitet. Det finns ingen snabbtangent bunden till den som standard.

`unbloarchy toggle screensaver` är det som stänger av den vid inaktivitet, om du hellre går direkt från arbete till låst. Vilken tangent, klick, rullning eller musrörelse som helst stänger den.

Logotypen den ritar är din att ändra, under _Appearance > Branding > Screensaver_. Ladda upp en png eller svg så konverterar Unbloarchy den till ASCII. Se [varumärkesprofilering](41-branding.md).

### Låsskärmen

`Super + Ctrl + L` låser maskinen. Det kör låsskärmen från Unbloarchy-skalet, släcker skärmen, återställer din tangentbordslayout till den första så att du inte skriver ditt lösenord i fel alfabet, och — om du har den igång — låser 1Password på vägen ut.

Låsskärmen tar ett lösenord, och den tar ett fingeravtryck också när du väl har ställt in ett. Det, och de andra sätten att autentisera, täcks i [hårdvaruautentisering](37-hardware-authentication.md).
