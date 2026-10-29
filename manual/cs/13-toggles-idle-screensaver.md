# Přepínače, nečinnost a spořič obrazovky

Spousta toho, co denně měníte, vlastně není nastavení. Je to režim, který na hodinu zapnete a pak zase vypnete: noční světlo, když pracujete dlouho do noci, nerušit, když prezentujete, zůstat vzhůru, když se na něco díváte. Unbloarchy jim říká přepínače a všechny fungují stejně — klávesová zkratka, položka v nabídce a příkaz, všechny míří na stejný přepínač.

### Nabídka přepínačů

`Super + Ctrl + O` otevře přímo _Trigger > Toggle_, nebo tam můžete dojít z nabídky Unbloarchy (`Super + Space`). Všechno v tom seznamu je přepínač, který můžete přepnout, aniž byste přemýšleli, kde se ten stav ukládá. Přepínače pro vzhled plochy sedí hned vedle, pod _Appearance_.

Z terminálu jsou tytéž přepínače `unbloarchy toggle <thing>`. Spusťte samotné `unbloarchy toggle` a uvidíte celou skupinu.

| Přepínač | Klávesová zkratka | Příkaz |
| ------ | ------ | ------- |
| Noční světlo | — | `unbloarchy toggle nightlight` |
| Ztišení oznámení | `Super + Ctrl + Alt + ,` | `unbloarchy toggle notification silencing` |
| Zůstat vzhůru (bez zamykání při nečinnosti) | `Super + Ctrl + I` | `unbloarchy toggle idle` |
| Zachytávání pádů | — | `unbloarchy toggle crash-capture` |
| Spořič obrazovky | — | `unbloarchy toggle screensaver` |
| Synchronizace motivu [Herdr](https://herdr.dev) | — | `unbloarchy toggle theme sync` |
| Horní lišta | `Super + Shift + Space` | `unbloarchy toggle bar` |
| Touchpad | `XF86TouchpadToggle` | `unbloarchy toggle touchpad` |
| Dotyková obrazovka | — | `unbloarchy toggle touchscreen` |
| Uspání | — | `unbloarchy toggle suspend` |
| Hybridní GPU | — | `unbloarchy toggle hybrid gpu` |

Přepínače touchpadu, dotykové obrazovky a hybridní GPU žijí pod _Trigger > Hardware_ (`Super + Ctrl + H`) spíše než pod Toggle, protože se zobrazí jen tehdy, když ten hardware skutečně máte. Přepínače touchpadu a dotykové obrazovky přežijí opětovné načtení Hyprland — název vypnutého zařízení se uloží do malého stavového souboru, který Hyprland při spuštění přečte, aby ho znovu vypnul.

_Appearance_ drží horní lištu a animace, plus pár věcí, které nejsou příkazy `unbloarchy toggle`, ale chovají se stejně: procenta baterie v liště, výchozí rozložení pracovních ploch a pod _Windows_ mezery mezi okny (`Super + Shift + Backspace`) a čtvercový poměr stran pro 1 okno (`Super + Ctrl + Backspace`).

Většina z nich je jen soubor s příznakem pod `~/.local/state/unbloarchy/toggles/`. Pokud na některém z nich chcete ve skriptu větvit, `unbloarchy-toggle-enabled` vám dá návratový kód, místo abyste ho museli hledat:

```bash
unbloarchy-toggle-enabled screensaver-off && echo "screensaver is off"
```

Příznaky jsou pojmenované podle vypnutého stavu — `screensaver-off`, `suspend-off`, `bar-off` — takže jejich přítomnost znamená, že je funkce vypnutá.

### Indikátory v liště

Když je nějaký režim zapnutý, dostanete malý glyf uprostřed horní lišty vedle hodin. To je widget indikátorů a nese diktování, nahrávání obrazovky, čekající připomínky, noční světlo, nerušit a zůstat vzhůru.

Neaktivní indikátory jsou skryté. Najeďte kamkoli na lištu a objeví se ztlumené, takže na jeden můžete kliknout a zapnout ho, aniž byste znali jeho klávesovou zkratku. Kliknutím na aktivní ho zase vypnete. Pokud je chcete raději vidět všechny pořád, nastavte `alwaysShow` na `true` u položky `unbloarchy.indicators` v `~/.config/unbloarchy/shell.json` — viz [horní lišta](05-the-top-bar.md), kde je popsáno, jak se widgety lišty konfigurují.

### Noční světlo

Noční světlo zahřeje obrazovku na 4000K a dalším přepnutím ji vrátí na 6500K. Přepnete ho z nabídky přepínačů (`Super + Ctrl + O`) nebo pomocí `unbloarchy toggle nightlight`. Pohání ho hyprsunset, který za vás přepínač spustí, pokud už neběží.

Ve výchozím nastavení hyprsunset s vaší obrazovkou nedělá vůbec nic. `~/.config/hypr/hyprsunset.conf` se dodává s identitním profilem právě proto, aby displej zůstal nedotčený, dokud si o teplo neřeknete. Pokud chcete raději přepínání podle hodin, nahraďte ho časovým profilem:

```
profile {
    time = 20:00
    temperature = 4000
}
```

Pak hyprsunset spouštějte při přihlášení přidáním `o.launch_on_start("hyprsunset")` do `~/.config/hypr/autostart.lua`. Dvojice 4000K/6500K, kterou přepínač používá, je pevná, takže pokud chcete jinou teplotu, musíte do konfiguračního souboru.

### Nerušit

`Super + Ctrl + Alt + ,` ztiší oznámení. Dokud je zapnuté, nevyskakují žádná toast oznámení a indikátor přeškrtnutého zvonku sedí v liště, aby vám připomínal, proč plocha ztichla.

Nic se ale neztratí. Ztišená oznámení se pozdrží: poslední pár jich vrátíte na obrazovku pomocí `Super + Shift + Alt + ,`. Zbytek viz [oznámení](10-notices.md).

Dva druhy zpráv přesto projdou: vlastní potvrzovací toasty Unbloarchy pro něco, co jste právě udělali ("Theme changed", "Screenshot saved"), a kritická upozornění odeslaná z příkazové řádky. Chatovací aplikace, které označují všechno jako kritické, aby si vynutily cestu před vás, se nepočítají.

### Nečinnost

Prostředí Unbloarchy vlastní chování při nečinnosti a časování je blok `idle` na nejvyšší úrovni v `~/.config/unbloarchy/shell.json`:

```json
{
  "version": 1,
  "idle": {
    "screensaver": 150,
    "lock": 300
  }
}
```

Obě čísla jsou sekundy počítané od okamžiku, kdy jste přestali být aktivní — ne od sebe navzájem. Takže ve výchozím nastavení spořič obrazovky naskočí po dvou a půl minutách a zamykací obrazovka převezme vládu v pěti minutách, ať už spořič běžel, nebo ne. Uložte soubor a prostředí nové časování převezme okamžitě.

Pokud spořič obrazovky zrušíte před termínem zamknutí, počítá se to jako aktivita a čekající zamknutí se zruší. Nebudete uzamčeni za to, že jste se na svůj počítač jen podívali.

Chcete-li úplně zastavit zamykání při nečinnosti, `Super + Ctrl + I` — nebo `unbloarchy toggle idle` — zapne režim zůstat vzhůru a v liště se objeví indikátor šálku kávy. Ten zmáčkněte před dlouhou prezentací nebo buildem, který chcete sledovat. Zmáčkněte ho znovu a vrátíte se k normálu. `unbloarchy toggle idle status` vypíše aktuální stav jako JSON, pokud ho potřebujete ze skriptu.

Tady jde o zamykání a spořič obrazovky, ne o napájení. Uspání a hibernace mají vlastní nastavení v [uspání systému](36-system-sleep.md).

### Spořič obrazovky

Spořič obrazovky Unbloarchy je ASCII art procházející náhodnými textovými efekty, jedna instance na monitor. Jakákoli klávesa nebo pohyb myši ho ukončí.

Můžete ho spustit na požádání ze _System > Screensaver_ (`Super + Esc`), což ho vynutí i tehdy, když jste spořič při nečinnosti vypnuli. Ve výchozím nastavení k němu není přiřazena žádná klávesová zkratka.

`unbloarchy toggle screensaver` je to, co vypne ten při nečinnosti, pokud chcete raději přejít rovnou od práce k zamknutí. Jakákoli klávesa, kliknutí, posun nebo pohyb myši ho zavře.

Logo, které kreslí, si můžete změnit pod _Appearance > Branding > Screensaver_. Nahrajte png nebo svg a Unbloarchy ho převede do ASCII. Viz [branding](41-branding.md).

### Zamykací obrazovka

`Super + Ctrl + L` zamkne počítač. To spustí zamykací obrazovku z prostředí Unbloarchy, zhasne displej, resetuje rozložení klávesnice na první, abyste nepsali heslo ve špatné abecedě, a — pokud ho máte spuštěný — cestou ven zamkne 1Password.

Zamykací obrazovka přijímá heslo a přijme i otisk prstu, jakmile si ho nastavíte. To a další způsoby ověřování pokrývá [ověřování pomocí hardwaru](37-hardware-authentication.md).
