# Togol, Melahu & Penyelamat Skrin

Banyak perkara yang anda ubah dari hari ke hari sebenarnya bukan tetapan. Ia mod yang anda hidupkan untuk sejam dan matikan semula: cahaya malam semasa anda bekerja lewat, jangan ganggu semasa anda membuat pembentangan, kekal berjaga semasa anda menonton sesuatu. Unbloarchy memanggilnya togol, dan semuanya berfungsi dengan cara yang sama — kekunci pintas, entri menu, dan arahan, semuanya menekan suis yang sama.

### Menu togol

`Super + Ctrl + O` membuka _Trigger > Toggle_ secara langsung, atau anda boleh pergi ke sana dari menu Unbloarchy (`Super + Space`). Segala-galanya dalam senarai itu ialah suis yang boleh anda togol tanpa perlu memikirkan di mana keadaannya disimpan. Suis untuk rupa desktop berada di sebelahnya, di bawah _Appearance_.

Dari terminal, suis yang sama ialah `unbloarchy toggle <thing>`. Jalankan `unbloarchy toggle` sendirian untuk melihat keseluruhan kumpulannya.

| Togol | Kekunci pintas | Arahan |
| ------ | ------ | ------- |
| Cahaya malam | — | `unbloarchy toggle nightlight` |
| Redamkan pemberitahuan | `Super + Ctrl + Alt + ,` | `unbloarchy toggle notification silencing` |
| Kekal berjaga (tiada kunci melahu) | `Super + Ctrl + I` | `unbloarchy toggle idle` |
| Tangkapan ranap | — | `unbloarchy toggle crash-capture` |
| Penyelamat skrin | — | `unbloarchy toggle screensaver` |
| Penyegerakan tema [Herdr](https://herdr.dev) | — | `unbloarchy toggle theme sync` |
| Bar menu | `Super + Shift + Space` | `unbloarchy toggle bar` |
| Pad sentuh | `XF86TouchpadToggle` | `unbloarchy toggle touchpad` |
| Skrin sentuh | — | `unbloarchy toggle touchscreen` |
| Tangguh | — | `unbloarchy toggle suspend` |
| GPU hibrid | — | `unbloarchy toggle hybrid gpu` |

Suis pad sentuh, skrin sentuh, dan GPU hibrid berada di bawah _Trigger > Hardware_ (`Super + Ctrl + H`) dan bukan di bawah Toggle, kerana suis tersebut hanya muncul apabila anda memang mempunyai perkakasan itu. Suis pad sentuh dan skrin sentuh kekal selepas Hyprland dimuat semula — nama peranti yang dilumpuhkan disimpan ke fail keadaan kecil yang dibaca oleh Hyprland semasa permulaan untuk melumpuhkannya semula.

_Appearance_ mengandungi bar menu dan animasi, serta beberapa perkara yang bukan arahan `unbloarchy toggle` tetapi berkelakuan sama: peratusan bateri dalam bar, susun atur ruang kerja lalai, dan di bawah _Windows_, jurang tetingkap (`Super + Shift + Backspace`) dan aspek segi empat sama 1 tetingkap (`Super + Ctrl + Backspace`).

Kebanyakan daripadanya hanyalah fail bendera di bawah `~/.local/state/unbloarchy/toggles/`. Jika anda mahu bercabang berdasarkannya dalam skrip, `unbloarchy-toggle-enabled` memberikan anda kod keluar dan bukannya memaksa anda mencarinya:

```bash
unbloarchy-toggle-enabled screensaver-off && echo "screensaver is off"
```

Bendera tersebut dinamakan mengikut keadaan mati — `screensaver-off`, `suspend-off`, `bar-off` — jadi kewujudannya bermakna ciri itu dilumpuhkan.

### Penunjuk dalam bar

Apabila sesuatu mod hidup, anda akan mendapat glif kecil di tengah bar atas di sebelah jam. Itulah widget penunjuk, dan ia mengandungi imlak, rakaman skrin, peringatan yang belum selesai, cahaya malam, jangan ganggu, dan kekal berjaga.

Penunjuk yang tidak aktif disembunyikan. Layangkan kursor di mana-mana pada bar dan penunjuk tersebut akan muncul perlahan-lahan dalam keadaan malap, supaya anda boleh mengklik satu untuk menghidupkannya tanpa mengetahui kekunci pintasnya. Mengklik penunjuk yang aktif akan mematikannya semula. Jika anda lebih suka melihat kesemuanya sepanjang masa, tetapkan `alwaysShow` kepada `true` pada entri `unbloarchy.indicators` dalam `~/.config/unbloarchy/shell.json` — lihat [bar atas](05-the-top-bar.md) untuk cara widget bar dikonfigurasikan.

### Cahaya malam

Cahaya malam memanaskan warna skrin kepada 4000K, dan menogolnya sekali lagi mengembalikannya kepada 6500K. Togolnya dari menu togol (`Super + Ctrl + O`) atau dengan `unbloarchy toggle nightlight`. Ia dipacu oleh hyprsunset, yang akan dimulakan oleh togol untuk anda jika ia belum berjalan.

Secara lalai, hyprsunset tidak melakukan apa-apa langsung pada skrin anda. `~/.config/hypr/hyprsunset.conf` disertakan dengan profil identiti tepat supaya paparan kekal tidak disentuh sehingga anda meminta kehangatan. Jika anda lebih suka ia bertukar mengikut jam, gantikan profil itu dengan profil masa:

```
profile {
    time = 20:00
    temperature = 4000
}
```

Kemudian mulakan hyprsunset semasa log masuk dengan menambahkan `o.launch_on_start("hyprsunset")` pada `~/.config/hypr/autostart.lua`. Pasangan 4000K/6500K yang digunakan oleh togol adalah tetap, jadi fail konfigurasi ialah tempatnya jika anda mahukan suhu yang berbeza.

### Jangan ganggu

`Super + Ctrl + Alt + ,` meredamkan pemberitahuan. Tiada toast muncul semasa ia hidup, dan penunjuk loceng yang dipangkah berada dalam bar untuk mengingatkan anda mengapa desktop menjadi senyap.

Namun, tiada apa yang hilang. Pemberitahuan yang diredamkan ditahan: paparkan beberapa pemberitahuan terakhir kembali pada skrin dengan `Super + Shift + Alt + ,`. Lihat [notis](10-notices.md) untuk selebihnya.

Dua jenis mesej masih boleh menembusinya: toast pengesahan Unbloarchy sendiri untuk sesuatu yang baru anda lakukan ("Theme changed", "Screenshot saved"), dan amaran kritikal yang dihantar dari baris arahan. Aplikasi sembang yang menandakan semuanya sebagai kritikal untuk memaksa laluannya di hadapan anda tidak layak.

### Melahu

Shell Unbloarchy mengawal kelakuan melahu, dan pemasaan ialah blok `idle` peringkat atas dalam `~/.config/unbloarchy/shell.json`:

```json
{
  "version": 1,
  "idle": {
    "screensaver": 150,
    "lock": 300
  }
}
```

Kedua-dua nombor ialah saat yang dikira dari saat anda mula melahu — bukan antara satu sama lain. Jadi dengan tetapan lalai, penyelamat skrin muncul selepas dua setengah minit dan skrin kunci mengambil alih pada lima minit, sama ada penyelamat skrin berjalan atau tidak. Simpan fail dan shell akan mengambil pemasaan baharu itu serta-merta.

Jika anda menutup penyelamat skrin sebelum tempoh akhir kunci, itu dikira sebagai aktiviti dan kunci yang belum selesai dibatalkan. Anda tidak akan terkunci hanya kerana menjenguk mesin anda.

Untuk berhenti mengunci semasa melahu sepenuhnya, `Super + Ctrl + I` — atau `unbloarchy toggle idle` — menghidupkan kekal berjaga, dan penunjuk cawan kopi muncul dalam bar. Itulah yang perlu ditekan sebelum pembentangan yang panjang atau binaan yang anda mahu tonton. Tekan sekali lagi untuk kembali seperti biasa. `unbloarchy toggle idle status` mencetak keadaan semasa sebagai JSON jika anda memerlukannya dari skrip.

Ini tentang penguncian dan penyelamat skrin, bukan kuasa. Tangguh dan hibernasi mempunyai persediaan sendiri dalam [tidur sistem](36-system-sleep.md).

### Penyelamat skrin

Penyelamat skrin Unbloarchy ialah seni ASCII yang melalui kesan teks rawak, satu instance bagi setiap monitor. Sebarang kekunci atau pergerakan tetikus akan keluar daripadanya.

Anda boleh memulakannya atas permintaan dari _System > Screensaver_ (`Super + Esc`), yang memaksanya muncul walaupun anda telah mematikan penyelamat skrin melahu. Secara lalai, tiada kekunci pintas yang terikat padanya.

`unbloarchy toggle screensaver` ialah yang mematikan penyelamat skrin melahu, jika anda lebih suka terus daripada bekerja kepada terkunci. Sebarang kekunci, klik, tatalan atau pergerakan tetikus akan menutupnya.

Logo yang dilukisnya boleh anda ubah, di bawah _Appearance > Branding > Screensaver_. Muat naik png atau svg dan Unbloarchy akan menukarnya kepada ASCII. Lihat [penjenamaan](41-branding.md).

### Skrin kunci

`Super + Ctrl + L` mengunci mesin. Itu menjalankan skrin kunci dari shell Unbloarchy, mengosongkan paparan, menetapkan semula susun atur papan kekunci anda kepada yang pertama supaya anda tidak menaip kata laluan anda dalam abjad yang salah, dan — jika anda menjalankannya — mengunci 1Password semasa keluar.

Skrin kunci menerima kata laluan, dan ia juga akan menerima cap jari setelah anda menyediakannya. Itu, dan cara lain untuk mengesahkan, dibincangkan dalam [pengesahan perkakasan](37-hardware-authentication.md).
