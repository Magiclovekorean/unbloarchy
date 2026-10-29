# Vigeuzaji, Kutotumika & Kihifadhi Skrini

Mengi ya unayobadilisha siku hadi siku si mipangilio hasa. Ni hali unayowasha kwa saa moja kisha unaizima tena: mwangaza wa usiku unapofanya kazi hadi usiku wa manane, usinisumbue unapowasilisha, kaa macho unapotazama kitu. Unbloarchy huziita hizo vigeuzaji, na zote hufanya kazi kwa njia moja — kitufe cha mkato, kipengele cha menyu, na amri, vyote vikigusa swichi moja.

### Menyu ya vigeuzaji

`Super + Ctrl + O` hufungua _Amsha > Geuza_ moja kwa moja, au unaweza kufika huko kutoka kwenye menyu ya Unbloarchy (`Super + Space`). Kila kitu kwenye orodha hiyo ni swichi unayoweza kugeuza bila kufikiria hali yake imehifadhiwa wapi. Swichi za jinsi eneo-kazi linavyoonekana ziko karibu nayo, chini ya _Muonekano_.

Kutoka kwenye terminali, swichi hizo hizo ni `unbloarchy toggle <thing>`. Endesha `unbloarchy toggle` yenyewe peke yake ili kuona kundi lote.

| Kigeuzaji | Kitufe cha mkato | Amri |
| ------ | ------ | ------- |
| Mwangaza wa usiku | — | `unbloarchy toggle nightlight` |
| Nyamazisha arifa | `Super + Ctrl + Alt + ,` | `unbloarchy toggle notification silencing` |
| Kaa macho (hakuna kufunga kwa kutotumika) | `Super + Ctrl + I` | `unbloarchy toggle idle` |
| Kunasa kuanguka | — | `unbloarchy toggle crash-capture` |
| Kihifadhi skrini | — | `unbloarchy toggle screensaver` |
| Ulinganishaji wa mandhari ya [Herdr](https://herdr.dev) | — | `unbloarchy toggle theme sync` |
| Upau wa menyu | `Super + Shift + Space` | `unbloarchy toggle bar` |
| Kipadi cha mguso | `XF86TouchpadToggle` | `unbloarchy toggle touchpad` |
| Skrini ya mguso | — | `unbloarchy toggle touchscreen` |
| Simamisha kwa muda | — | `unbloarchy toggle suspend` |
| GPU mseto | — | `unbloarchy toggle hybrid gpu` |

Swichi za kipadi cha mguso, skrini ya mguso, na GPU mseto ziko chini ya _Amsha > Vifaa_ (`Super + Ctrl + H`) badala ya chini ya Geuza, kwa kuwa huonekana tu unapokuwa na vifaa hivyo hasa. Za kipadi cha mguso na skrini ya mguso hudumu baada ya Hyprland kupakiwa upya — jina la kifaa kilichozimwa huhifadhiwa kwenye faili ndogo ya hali ambayo Hyprland huisoma wakati wa kuanza ili kukizima tena.

_Muonekano_ hushikilia upau wa menyu na uhuishaji, pamoja na vitu vichache ambavyo si amri za `unbloarchy toggle` lakini hufanya kazi sawa: asilimia ya betri kwenye upau, mpangilio chaguomsingi wa eneo la kazi, na chini ya _Madirisha_, mapengo ya madirisha (`Super + Shift + Backspace`) na uwiano wa mraba wa dirisha 1 (`Super + Ctrl + Backspace`).

Nyingi kati ya hizi ni faili tu ya bendera chini ya `~/.local/state/unbloarchy/toggles/`. Ukitaka kuamua kulingana na mojawapo kwenye skripti, `unbloarchy-toggle-enabled` hukupa msimbo wa kutoka badala ya kukulazimisha kwenda kuitafuta:

```bash
unbloarchy-toggle-enabled screensaver-off && echo "screensaver is off"
```

Bendera zimepewa majina ya hali ya kuzimwa — `screensaver-off`, `suspend-off`, `bar-off` — hivyo kuwepo kwake kunamaanisha kipengele kimezimwa.

### Viashiria kwenye upau

Hali inapowashwa, unapata glifu ndogo katikati ya upau wa juu karibu na saa. Hiyo ndiyo wijeti ya viashiria, na hubeba kunukuu kwa sauti, kurekodi skrini, vikumbusho vinavyosubiri, mwangaza wa usiku, usinisumbue, na kaa macho.

Viashiria visivyotumika hufichwa. Elekeza kipanya popote kwenye upau na huonekana vikiwa vimefifia, ili uweze kubofya kimoja ukiwishe bila kujua kitufe chake cha mkato. Kubofya kilichowashwa hukizima tena. Ikiwa ungependa kuviona vyote kila wakati, weka `alwaysShow` kuwa `true` kwenye kipengele cha `unbloarchy.indicators` katika `~/.config/unbloarchy/shell.json` — angalia [upau wa juu](05-the-top-bar.md) ili kuona jinsi wijeti za upau zinavyosanidiwa.

### Mwangaza wa usiku

Mwangaza wa usiku hufanya skrini iwe na joto hadi 4000K, na kuugeuza tena huirudisha hadi 6500K. Ugeuze kutoka kwenye menyu ya vigeuzaji (`Super + Ctrl + O`) au kwa `unbloarchy toggle nightlight`. Unaendeshwa na hyprsunset, ambayo kigeuzaji hukianzisha kwa ajili yako ikiwa hakijaanza tayari.

Kwa chaguomsingi hyprsunset haifanyi chochote kwenye skrini yako hata kidogo. `~/.config/hypr/hyprsunset.conf` huja na wasifu wa utambulisho makusudi ili onyesho libaki bila kuguswa hadi uombe joto. Ikiwa ungependa kibadilike kulingana na saa, badilisha huo na wasifu wa wakati:

```
profile {
    time = 20:00
    temperature = 4000
}
```

Kisha anzisha hyprsunset wakati wa kuingia kwa kuongeza `o.launch_on_start("hyprsunset")` kwenye `~/.config/hypr/autostart.lua`. Jozi ya 4000K/6500K inayotumiwa na kigeuzaji ni thabiti, hivyo faili ya usanidi ndipo unapoenda ikiwa unataka halijoto tofauti.

### Usinisumbue

`Super + Ctrl + Alt + ,` hunyamazisha arifa. Hakuna arifa ibukizi zinazotokea ikiwa imewashwa, na kiashiria cha kengele iliyokatwa hukaa kwenye upau kukukumbusha kwa nini eneo-kazi limekuwa kimya.

Hakuna kinachopotea, hata hivyo. Arifa zilizonyamazishwa hushikiliwa: zirudishe chache za mwisho kwenye skrini kwa `Super + Shift + Alt + ,`. Angalia [taarifa](10-notices.md) kwa mengine.

Aina mbili za ujumbe bado hupita: arifa za uthibitisho za Unbloarchy yenyewe kwa kitu ulichofanya hivi punde ("Mandhari yamebadilika", "Picha ya skrini imehifadhiwa"), na tahadhari muhimu zinazotumwa kutoka kwenye mstari wa amri. Programu za gumzo zinazoweka kila kitu kuwa muhimu ili kujilazimisha mbele yako hazistahili.

### Kutotumika

Ganda la Unbloarchy humiliki tabia ya kutotumika, na muda wake ni kizuizi cha kiwango cha juu cha `idle` katika `~/.config/unbloarchy/shell.json`:

```json
{
  "version": 1,
  "idle": {
    "screensaver": 150,
    "lock": 300
  }
}
```

Namba zote mbili ni sekunde zinazohesabiwa kutoka wakati ulipoacha kutumika — si kutoka kwa kila moja. Hivyo kwa chaguomsingi, kihifadhi skrini huja baada ya dakika mbili na nusu na skrini ya kufunga huchukua nafasi baada ya dakika tano, iwe kihifadhi skrini kilifanya kazi au la. Hifadhi faili na ganda huchukua muda mpya mara moja.

Ukifutilia mbali kihifadhi skrini kabla ya muda wa mwisho wa kufunga, hiyo huhesabika kama shughuli na kufunga kunakosubiri hubatilishwa. Hufungiwi nje kwa kuangalia tu mashine yako.

Ili kuacha kufunga kwa kutotumika kabisa, `Super + Ctrl + I` — au `unbloarchy toggle idle` — hugeuza kaa macho iwake, na kiashiria cha kikombe cha kahawa huonekana kwenye upau. Hicho ndicho cha kubofya kabla ya wasilisho refu au ujenzi unaotaka kutazama. Kibofye tena ili kurudi kawaida. `unbloarchy toggle idle status` huchapisha hali ya sasa kama JSON ikiwa unaihitaji kutoka kwenye skripti.

Hii ni kuhusu kufunga na kihifadhi skrini, si nishati. Usimamishaji kwa muda na hibernation vina usanidi wao wenyewe katika [kulala kwa mfumo](36-system-sleep.md).

### Kihifadhi skrini

Kihifadhi skrini cha Unbloarchy ni sanaa ya ASCII inayoendeshwa kupitia athari za maandishi za nasibu, tukio moja kwa kila monita. Kitufe chochote au mwendo wa kipanya hukiondoa.

Unaweza kukianzisha unapokihitaji kutoka _Mfumo > Kihifadhi Skrini_ (`Super + Esc`), ambayo hukilazimisha kiwake hata kama umezima kihifadhi skrini cha kutotumika. Hakuna kitufe cha mkato kilichofungwa kwake kwa chaguomsingi.

`unbloarchy toggle screensaver` ndicho kinachozima cha kutotumika, ikiwa ungependa kwenda moja kwa moja kutoka kufanya kazi hadi kufungiwa. Kitufe chochote, kubofya, kusogeza au mwendo wa kipanya hukifunga.

Nembo inayochora ni yako kubadilisha, chini ya _Muonekano > Chapa > Kihifadhi Skrini_. Pakia png au svg na Unbloarchy huibadilisha kuwa ASCII. Angalia [chapa](41-branding.md).

### Skrini ya kufunga

`Super + Ctrl + L` hufunga mashine. Hiyo huendesha skrini ya kufunga kutoka kwenye ganda la Unbloarchy, huweka onyesho giza, huweka upya mpangilio wa kibodi yako kuwa wa kwanza ili usiandike nenosiri lako kwa alfabeti isiyo sahihi, na — ikiwa unaiendesha — hufunga 1Password wakati wa kutoka.

Skrini ya kufunga huchukua nenosiri, na itachukua pia alama ya kidole mara tu unapokuwa umeiweka. Hiyo, na njia nyingine za kujithibitisha, zimeelezewa katika [uthibitishaji wa vifaa](37-hardware-authentication.md).
