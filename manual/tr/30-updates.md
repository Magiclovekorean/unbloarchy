# Güncellemeler

Unbloarchy ve paketleriniz, Unbloarchy menüsündeki (`Super + Space`) _Update > Unbloarchy_ aracılığıyla güncel tutulur.

Unbloarchy'nin kendisi, [Unbloarchy Paket Deposu](https://github.com/omacom-io/omarchy-pkgs) üzerinden normal pacman paketleri olarak kurulur; dolayısıyla bir güncelleme [en son Unbloarchy sürümünü](https://github.com/omacom/omarchy/releases) kurar, sisteminizi en son sürümle senkronize etmek için bekleyen tüm geçişleri çalıştırır ve [Unbloarchy Arch Yansısı](https://github.com/omacom-io/omarchy-mirror) ile [AUR](https://aur.archlinux.org/) üzerindeki tüm sistem paketlerini günceller (herhangi bir AUR paketi kurduysanız).

Yeni sürümler çıktığında, saatinizin sağında bir daire ok simgesi görünecektir. Ona tıklayın, güncelleme işlemi başlayacaktır.

![update-available](images/update-available.webp)

### Dört kanal

Unbloarchy dört kanal üzerinden güncellenir: stable, RC, edge ve dev. Yeni kurulumlar, [resmi sürümleri](https://github.com/omacom/omarchy/releases/) takip eden stable kanalıyla başlar. Aynı zamanda bir ay geriden gelen [kararlı Unbloarchy Arch yansısını](https://github.com/omacom-io/omarchy-mirror) kullanır; böylece yapılandırma değişikliği gerektiren yeni uyumsuzlukları, insanlara sorun çıkarmadan önce yakalayabiliriz.

Ama bu olası sorunları tespit etmeye yardımcı olmak isterseniz, edge kanalında çalışabilirsiniz. Bu, Unbloarchy paketlerinizin en son geliştirme derlemelerini takip etmesini sağlar ve en son Arch paketlerine çıkar çıkmaz güncellemenize olanak tanır. Bunu yalnızca Linux konusunda deneyimliyseniz ve sorun yaşayan bir sistemi nasıl kurtaracağınızı biliyorsanız yapmalısınız.

Her yeni büyük sürümden önce, RC kanalını kullanarak son doğrulamayı yapacağız. Son rötuşlara yardımcı olmak isterseniz, Discord'daki #unbloarchy-release-candidates kanalına gelip takılın.

Son olarak, Unbloarchy'yi doğrudan `~/unbloarchy` içindeki kaynak kodun bir git checkout'una bağlayan ve edge paketleriyle birleştiren dev kanalı var. Bu kanalı yalnızca deneyimli bir Linux kullanıcısıysanız, doğrudan Unbloarchy üzerinde çalışıyorsanız ve bozulmalara katlanmaya razıysanız kullanmalısınız.

Unbloarchy menüsündeki _Update > Channel_ seçeneğini (veya terminalde `unbloarchy-channel-set` komutunu) kullanarak kanallar arasında geçiş yapabilirsiniz.

### Çekirdek değiştirme

Unbloarchy kendi `linux-omarchy` çekirdeğini önyükler, ancak standart Arch `linux` çekirdeği veya test ettiğiniz deneysel bir derleme gibi diğer çekirdekleri de yanında kurulu tutabilirsiniz. Birden fazla çekirdek olduğunda, Unbloarchy menüsündeki _Update > Kernel_, varsayılan olarak önyüklenen çekirdeğin yanında bir onay işaretiyle bunları listeler. Başka birini seçin, parolanızı bir kez girin, bir sonraki yeniden başlatmadan sonra o önyüklenir. Diğer çekirdekler önyükleme menüsünde kalır; böylece yeni varsayılan size sorun çıkarırsa yine de elle birini seçebilirsiniz. Terminalde, geçerli varsayılanı görmek için `unbloarchy-kernel`, kurulu olanlar için `unbloarchy-kernel list` ve geçiş yapmak için `unbloarchy-kernel set <kernel>` komutunu kullanın.

### Donanım yazılımı güncellemeleri

Eski hâle gelen tek şey paketleriniz değildir. Birçok dizüstü bilgisayar ve çevre birimi; BIOS, SSD ve dock donanım yazılımlarını Linux Vendor Firmware Service aracılığıyla sunar ve Unbloarchy menüsündeki _Update > Firmware_, donanımınız için bekleyen her şeyi getirip kurar. İlk çalıştırdığınızda `fwupd` paketini kurar. Birçok donanım yazılımı yalnızca yeniden başlatma sırasında yazılabilir, bu yüzden sizden yeniden başlatma istenirse şaşırmayın.

### Doğrudan pacman/yay güncellemeleri hakkında uyarı

Arch'e zaten aşinaysanız, kendiniz `pacman -Syu` veya `yay -Syu` çalıştırma isteği duyabilirsiniz, ancak bunu yaparsanız Unbloarchy'nin yeni paketlerle birlikte çalıştırdığı anlık görüntüyü, geçişleri ve yapılandırma güncellemelerini kaçırırsınız. Bu yüzden Unbloarchy doğrudan bir sistem yükseltmesini aslında durdurur ve sizi bunun yerine `unbloarchy update` komutuna yönlendirir. (Gerçekten ne yaptığınızı biliyorsanız, koruma size tek bir işlem için bunu nasıl atlayacağınızı söyler.)

### Bozuk güncellemeleri geri alma

Bir güncelleme yaptıktan sonra bir sorun yaşarsanız, sisteminizi güncellemeden önce alınan anlık görüntüye geri alabilirsiniz. Tek yapmanız gereken yeniden başlatmak ve önyükleme menüsünden güncellemeyi başlatmadan önceki anlık görüntüyü seçmek.

![bootloader](images/bootloader.webp)

Yapılandırma dosyalarınız bir şekilde bozulduysa, terminalde `unbloarchy reinstall` komutunu kullanarak Unbloarchy'yi yeniden de kurabilirsiniz. Bu, tüm varsayılan Unbloarchy paketlerini yeniden kurar, sizi stable kanalına alır ve çok yeni olan tüm paketlerin sürümünü düşürür, ayrıca tüm yapılandırma dosyalarını sıfırlar. Bunu yaparken Unbloarchy varsayılanlarına yaptığınız tüm kullanıcı yapılandırma değişikliklerinin üzerine yazılacağını unutmayın!
