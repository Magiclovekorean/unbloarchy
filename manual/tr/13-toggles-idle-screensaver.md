# Aç/Kapat Düğmeleri, Boşta Kalma ve Ekran Koruyucu

Gün içinde değiştirdiğiniz şeylerin çoğu aslında bir ayar değildir. Bir saatliğine açıp sonra tekrar kapattığınız bir moddur: geç saatlere kadar çalışırken gece ışığı, sunum yaparken rahatsız etme, bir şey izlerken uyanık kalma. Unbloarchy bunlara aç/kapat düğmeleri der ve hepsi aynı şekilde çalışır — bir kısayol tuşu, bir menü girişi ve bir komut, hepsi aynı düğmeye basar.

### Aç/kapat menüsü

`Super + Ctrl + O` doğrudan _Trigger > Toggle_ menüsünü açar veya Unbloarchy menüsünden (`Super + Space`) oraya yürüyebilirsiniz. O listedeki her şey, durumun nerede yaşadığını düşünmeden çevirebileceğiniz bir düğmedir. Masaüstünün nasıl göründüğüne dair düğmeler, onun yanında, _Appearance_ altında durur.

Terminalden, aynı düğmeler `unbloarchy toggle <thing>` şeklindedir. Grubun tamamını görmek için `unbloarchy toggle` komutunu tek başına çalıştırın.

| Aç/Kapat Düğmesi | Kısayol Tuşu | Komut |
| ------ | ------ | ------- |
| Gece ışığı | — | `unbloarchy toggle nightlight` |
| Bildirimleri sessize al | `Super + Ctrl + Alt + ,` | `unbloarchy toggle notification silencing` |
| Uyanık kal (boşta kilidi yok) | `Super + Ctrl + I` | `unbloarchy toggle idle` |
| Çökme yakalama | — | `unbloarchy toggle crash-capture` |
| Ekran koruyucu | — | `unbloarchy toggle screensaver` |
| [Herdr](https://herdr.dev) tema senkronizasyonu | — | `unbloarchy toggle theme sync` |
| Menü çubuğu | `Super + Shift + Space` | `unbloarchy toggle bar` |
| Dokunmatik yüzey | `XF86TouchpadToggle` | `unbloarchy toggle touchpad` |
| Dokunmatik ekran | — | `unbloarchy toggle touchscreen` |
| Askıya al | — | `unbloarchy toggle suspend` |
| Hibrit GPU | — | `unbloarchy toggle hybrid gpu` |

Dokunmatik yüzey, dokunmatik ekran ve hibrit GPU düğmeleri Toggle altında değil, _Trigger > Hardware_ (`Super + Ctrl + H`) altında bulunur, çünkü yalnızca o donanıma gerçekten sahipseniz görünürler. Dokunmatik yüzey ve dokunmatik ekran düğmeleri Hyprland yeniden yüklemesinden sağ çıkar — devre dışı bırakılan aygıtın adı, Hyprland'in başlangıçta tekrar devre dışı bırakmak için okuduğu küçük bir durum dosyasına kaydedilir.

_Appearance_, menü çubuğunu ve animasyonları barındırır, ayrıca `unbloarchy toggle` komutu olmayan ama aynı şekilde davranan birkaç şeyi de: çubuktaki pil yüzdesi, varsayılan çalışma alanı düzeni ve _Windows_ altında, pencere boşlukları (`Super + Shift + Backspace`) ve 1 pencereli kare en-boy oranı (`Super + Ctrl + Backspace`).

Bunların çoğu yalnızca `~/.local/state/unbloarchy/toggles/` altında bir bayrak dosyasıdır. Bir betikte birine göre dallanmak isterseniz, `unbloarchy-toggle-enabled` sizi aramaya göndermek yerine size bir çıkış kodu verir:

```bash
unbloarchy-toggle-enabled screensaver-off && echo "screensaver is off"
```

Bayraklar kapalı duruma göre adlandırılır — `screensaver-off`, `suspend-off`, `bar-off` — yani varlıkları özelliğin devre dışı olduğu anlamına gelir.

### Çubuktaki göstergeler

Bir mod açıkken, üst çubuğun ortasında saatin yanında küçük bir simge görürsünüz. Bu, göstergeler widget'ıdır ve dikteyi, ekran kaydını, bekleyen hatırlatıcıları, gece ışığını, rahatsız etme modunu ve uyanık kalmayı taşır.

Etkin olmayan göstergeler gizlidir. Çubuğun herhangi bir yerinde gezinin, soluk bir şekilde belirirler, böylece kısayol tuşunu bilmeden birine tıklayıp açabilirsiniz. Etkin birine tıklamak onu tekrar kapatır. Hepsini her zaman görmeyi tercih ederseniz, `~/.config/unbloarchy/shell.json` içindeki `unbloarchy.indicators` girişinde `alwaysShow` değerini `true` olarak ayarlayın — çubuk widget'larının nasıl yapılandırıldığı için [üst çubuk](05-the-top-bar.md) bölümüne bakın.

### Gece ışığı

Gece ışığı ekranı 4000K'ye ısıtır ve tekrar açıp kapattığınızda 6500K'ye geri getirir. Aç/kapat menüsünden (`Super + Ctrl + O`) veya `unbloarchy toggle nightlight` ile çevirin. Bunu hyprsunset çalıştırır; zaten çalışmıyorsa düğme onu sizin için başlatır.

Varsayılan olarak hyprsunset ekranınıza hiçbir şey yapmaz. `~/.config/hypr/hyprsunset.conf`, siz sıcaklık isteyene kadar ekranın dokunulmadan kalması için tam olarak bir kimlik profiliyle gelir. Saate göre geçiş yapmasını tercih ederseniz, bunu bir zaman profiliyle değiştirin:

```
profile {
    time = 20:00
    temperature = 4000
}
```

Ardından `~/.config/hypr/autostart.lua` dosyasına `o.launch_on_start("hyprsunset")` ekleyerek hyprsunset'i girişte başlatın. Düğmenin kullandığı 4000K/6500K çifti sabittir, yani farklı bir sıcaklık istiyorsanız gideceğiniz yer yapılandırma dosyasıdır.

### Rahatsız etme

`Super + Ctrl + Alt + ,` bildirimleri sessize alır. Açıkken hiçbir bildirim baloncuğu çıkmaz ve üstü çizili zil göstergesi, masaüstünün neden sessizleştiğini hatırlatmak için çubukta durur.

Yine de hiçbir şey kaybolmaz. Sessize alınan bildirimler geri tutulur: son birkaçını `Super + Shift + Alt + ,` ile tekrar ekrana getirin. Geri kalanı için [bildirimler](10-notices.md) bölümüne bakın.

İki tür mesaj yine de geçer: Unbloarchy'nin az önce yaptığınız bir şey için kendi onay bildirimleri ("Theme changed", "Screenshot saved") ve komut satırından gönderilen kritik uyarılar. Önünüze zorla çıkmak için her şeyi kritik olarak işaretleyen sohbet uygulamaları buna dahil değildir.

### Boşta kalma

Unbloarchy kabuğu boşta kalma davranışını yönetir ve zamanlamalar `~/.config/unbloarchy/shell.json` içinde üst düzey bir `idle` bloğudur:

```json
{
  "version": 1,
  "idle": {
    "screensaver": 150,
    "lock": 300
  }
}
```

Her iki sayı da boşta kalmaya başladığınız andan itibaren sayılan saniyelerdir — birbirinden itibaren değil. Yani varsayılanlarla, ekran koruyucu iki buçuk dakika sonra çıkar ve ekran koruyucu çalışmış olsun ya da olmasın, kilit ekranı beş dakikada devralır. Dosyayı kaydedin, kabuk yeni zamanlamaları hemen alır.

Ekran koruyucuyu kilit süresi dolmadan kapatırsanız, bu etkinlik sayılır ve bekleyen kilit iptal edilir. Makinenize göz attığınız için kilitlenmezsiniz.

Boşta kalınca kilitlemeyi tamamen durdurmak için, `Super + Ctrl + I` — veya `unbloarchy toggle idle` — uyanık kalmayı açar ve çubukta kahve fincanı göstergesi belirir. Uzun bir sunumdan veya izlemek istediğiniz bir derlemeden önce basacağınız düğme budur. Normale dönmek için tekrar basın. Bir betikten ihtiyacınız olursa, `unbloarchy toggle idle status` geçerli durumu JSON olarak yazdırır.

Bu, güçle değil, kilitleme ve ekran koruyucuyla ilgilidir. Askıya alma ve hazırda bekletmenin kendi kurulumu [sistem uykusu](36-system-sleep.md) bölümündedir.

### Ekran koruyucu

Unbloarchy'nin ekran koruyucusu, rastgele metin efektlerinden geçen ASCII sanatıdır, her monitör için bir örnek çalışır. Herhangi bir tuş veya fare hareketi ondan çıkar.

Onu _System > Screensaver_ (`Super + Esc`) üzerinden isteğe bağlı başlatabilirsiniz; bu, boşta ekran koruyucusunu kapatmış olsanız bile onu zorla çıkarır. Varsayılan olarak ona atanmış bir kısayol tuşu yoktur.

Doğrudan çalışmaktan kilitli duruma geçmeyi tercih ederseniz, boşta ekran koruyucusunu kapatan şey `unbloarchy toggle screensaver` komutudur. Herhangi bir tuş, tıklama, kaydırma veya fare hareketi onu kapatır.

Çizdiği logo size aittir, _Appearance > Branding > Screensaver_ altında değiştirebilirsiniz. Bir png veya svg yükleyin, Unbloarchy onu ASCII'ye dönüştürür. [markalama](41-branding.md) bölümüne bakın.

### Kilit ekranı

`Super + Ctrl + L` makineyi kilitler. Bu, Unbloarchy kabuğundan kilit ekranını çalıştırır, ekranı karartır, parolanızı yanlış alfabede yazmamanız için klavye düzeninizi ilkine sıfırlar ve — çalıştırıyorsanız — çıkarken 1Password'ü kilitler.

Kilit ekranı bir parola kabul eder ve bir kez ayarladıktan sonra parmak izini de kabul eder. Bu ve kimlik doğrulamanın diğer yolları [donanım kimlik doğrulaması](37-hardware-authentication.md) bölümünde ele alınır.
