# Yangilanishlar

Unbloarchy va paketlaringiz Unbloarchy menyusidagi (`Super + Space`) _Update > Unbloarchy_ orqali yangilab boriladi.

Unbloarchy o‘zi [Unbloarchy Package Repository](https://github.com/omacom-io/omarchy-pkgs) dan oddiy pacman paketlari sifatida o‘rnatiladi, shuning uchun yangilanish [eng so‘nggi Unbloarchy relizini](https://github.com/omacom/omarchy/releases) o‘rnatadi, tizimingizni eng so‘nggisi bilan sinxron holatga keltirish uchun kutilayotgan barcha migratsiyalarni ishga tushiradi va [Unbloarchy Arch Mirror](https://github.com/omacom-io/omarchy-mirror) hamda [AUR](https://aur.archlinux.org/) dan (agar birorta AUR paketini o‘rnatgan bo‘lsangiz) barcha tizim paketlarini yangilaydi.

Yangi relizlar chiqqanda, soatingizning o‘ng tomonida doiraviy strelka belgisi paydo bo‘ladi. Uni bosing va yangilash jarayoni boshlanadi.

![update-available](images/update-available.webp)

### To‘rtta kanal

Unbloarchy to‘rtta kanal bo‘ylab yangilanadi: stable, RC, edge va dev. Yangi o‘rnatishlar [rasmiy relizlarni](https://github.com/omacom/omarchy/releases/) kuzatib boradigan stable kanalda, shuningdek eng so‘nggisidan bir oy orqada yuradigan [barqaror Unbloarchy Arch mirror](https://github.com/omacom-io/omarchy-mirror) da boshlanadi, shunda biz konfiguratsiyaga o‘zgartirish kiritishni talab qiladigan har qanday yangi nomuvofiqliklarni ular odamlarga muammo tug‘dirishidan oldin ushlab qolishimiz mumkin.

Ammo agar o‘sha ehtimoliy muammolarni aniqlashga yordam bermoqchi bo‘lsangiz, edge kanalida ishlashingiz mumkin. Bu Unbloarchy paketlaringizni eng so‘nggi ishlab chiqish buildlarini kuzatib boradigan qiladi va eng so‘nggi Arch paketlari paydo bo‘lishi bilanoq ularga yangilash imkonini beradi. Buni faqat Linux bilan tajribangiz bo‘lsagina va muammoga uchragan tizimni qanday tiklashni bilsangizgina qiling.

Har qanday yangi yirik relizdan oldin, RC kanalidan foydalanib yakuniy tekshiruvni o‘tkazamiz. Agar yakuniy sayqallashda yordam berishga qiziqsangiz, Discord dagi #unbloarchy-release-candidates ga kelib, biz bilan muloqot qiling.

Va nihoyat, dev kanali bor, u Unbloarchy ni to‘g‘ridan-to‘g‘ri `~/unbloarchy` dagi manba kodining git checkout iga, edge paketlari bilan birgalikda bog‘laydi. Bu kanaldan faqat tajribali Linux foydalanuvchisi bo‘lsangiz, to‘g‘ridan-to‘g‘ri Unbloarchy ustida ishlayotgan bo‘lsangiz va buzilishlarga chidashga tayyor bo‘lsangizgina foydalaning.

Kanallar o‘rtasida Unbloarchy menyusidagi _Update > Channel_ yordamida (yoki terminalda `unbloarchy-channel-set` yordamida) almashishingiz mumkin.

### Yadrolarni almashtirish

Unbloarchy o‘zining `linux-omarchy` yadrosini yuklaydi, ammo uning yonida boshqalarini ham o‘rnatilgan holda saqlashingiz mumkin, masalan, standart Arch `linux` yadrosi yoki siz sinab ko‘rayotgan eksperimental build. Bittadan ortiq yadro bo‘lganda, Unbloarchy menyusidagi _Update > Kernel_ ularni ro‘yxat qilib ko‘rsatadi, yonida esa sukut bo‘yicha yuklanadiganining yonida belgi bo‘ladi. Boshqasini tanlang, parolingizni bir marta kiriting va u keyingi qayta ishga tushirishdan keyin yuklanadi. Boshqa yadrolar yuklash menyusida qoladi, shuning uchun yangi sukut bo‘yicha yadro sizga muammo tug‘dirsa, baribir qo‘lda bittasini tanlashingiz mumkin. Terminalda joriy sukut bo‘yicha yadroni ko‘rish uchun `unbloarchy-kernel`, nima o‘rnatilganini ko‘rish uchun `unbloarchy-kernel list` va almashtirish uchun `unbloarchy-kernel set <kernel>` ishlatiladi.

### Mikrodastur yangilanishlari

Eskirib qoladigan yagona narsa paketlaringiz emas. Ko‘plab noutbuklar va periferiya qurilmalari BIOS, SSD va dok mikrodasturlarini Linux Vendor Firmware Service orqali yetkazib beradi va Unbloarchy menyusidagi _Update > Firmware_ qurilmangizda kutib turgan narsalarning hammasini olib keladi va o‘rnatadi. U birinchi marta ishga tushirganingizda `fwupd` ni o‘rnatadi. Ko‘plab mikrodasturlarni faqat qayta ishga tushirish paytida yozish mumkin, shuning uchun sizdan qayta ishga tushirish so‘ralsa, hayron bo‘lmang.

### To‘g‘ridan-to‘g‘ri pacman/yay yangilanishlari haqida ogohlantirish

Agar Arch bilan allaqachon tanish bo‘lsangiz, shunchaki o‘zingiz `pacman -Syu` yoki `yay -Syu` ni ishga tushirishga vasvasaga tushishingiz mumkin, ammo agar shunday qilsangiz, Unbloarchy yangi paketlar bilan birgalikda ishga tushiradigan snapshot, migratsiyalar va konfiguratsiya yangilanishlarini o‘tkazib yuborasiz. Shuning uchun Unbloarchy aslida to‘g‘ridan-to‘g‘ri tizimni yangilashni to‘xtatadi va buning o‘rniga sizni `unbloarchy update` ga yo‘naltiradi. (Agar haqiqatan ham nima qilayotganingizni bilsangiz, himoya sizga uni bitta tranzaksiya uchun qanday chetlab o‘tishni aytib beradi.)

### Yomon yangilanishlarni orqaga qaytarish

Agar yangilanishni amalga oshirgandan keyin hech qachon muammoga duch kelsangiz, tizimingizni yangilanishdan oldin olingan snapshot ga orqaga qaytarishingiz mumkin. Shunchaki qayta ishga tushiring va yuklash menyusida yangilanishni boshlashingizdan oldingi snapshot ni tanlang.

![bootloader](images/bootloader.webp)

Agar qandaydir tarzda konfiguratsiya fayllaringiz buzilgan bo‘lsa, terminalda `unbloarchy reinstall` yordamida Unbloarchy ni qayta o‘rnatishni ham amalga oshirishingiz mumkin. Bu barcha standart Unbloarchy paketlarini qayta o‘rnatadi, sizni stable ga o‘tkazadi va juda yangi bo‘lgan har qanday paketlarni pasaytiradi hamda barcha konfiguratsiya fayllarini tiklaydi. E’tibor bering, buni qilish Unbloarchy standartlariga kiritgan barcha foydalanuvchi konfiguratsiya o‘zgartirishlaringizni ustidan yozib yuboradi!
