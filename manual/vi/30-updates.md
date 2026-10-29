# Cập nhật

Unbloarchy và các gói của bạn luôn được cập nhật thông qua _Cập nhật > Unbloarchy_ trong menu Unbloarchy (`Super + Space`).

Bản thân Unbloarchy được cài đặt dưới dạng các gói pacman thông thường từ [Kho gói Unbloarchy](https://github.com/omacom-io/omarchy-pkgs), vì vậy một lần cập nhật sẽ cài đặt [bản phát hành Unbloarchy mới nhất](https://github.com/omacom/omarchy/releases), chạy mọi quá trình di chuyển đang chờ xử lý để đồng bộ hệ thống của bạn với phiên bản mới nhất, và cập nhật tất cả các gói hệ thống từ [Unbloarchy Arch Mirror](https://github.com/omacom-io/omarchy-mirror) và [AUR](https://aur.archlinux.org/) (nếu bạn đã cài đặt bất kỳ gói AUR nào).

Khi có bản phát hành mới, một biểu tượng mũi tên vòng tròn sẽ xuất hiện ở bên phải đồng hồ của bạn. Nhấp vào nó và quá trình cập nhật sẽ bắt đầu.

![update-available](images/update-available.webp)

### Bốn kênh

Unbloarchy được cập nhật theo bốn kênh: stable, RC, edge và dev. Các bản cài đặt mới bắt đầu trên kênh stable, kênh này theo dõi các [bản phát hành chính thức](https://github.com/omacom/omarchy/releases/), cũng như [mirror Arch ổn định của Unbloarchy](https://github.com/omacom-io/omarchy-mirror) đang chạy chậm hơn phiên bản mới nhất một tháng, để chúng tôi có thể phát hiện mọi sự không tương thích mới cần thay đổi cấu hình trước khi chúng gây ra vấn đề cho mọi người.

Nhưng nếu bạn muốn giúp phát hiện những vấn đề tiềm ẩn đó, bạn có thể chạy trên kênh edge. Điều đó sẽ giữ cho các gói Unbloarchy của bạn theo dõi các bản dựng phát triển mới nhất, và cho phép bạn cập nhật lên các gói Arch mới nhất ngay khi chúng có sẵn. Bạn chỉ nên làm điều này nếu bạn có kinh nghiệm với Linux, và biết cách khôi phục một hệ thống gặp sự cố.

Trước mỗi bản phát hành lớn mới, chúng tôi sẽ thực hiện bước kiểm tra cuối cùng bằng kênh RC. Nếu bạn quan tâm đến việc giúp hoàn thiện những bước cuối cùng, hãy ghé qua #unbloarchy-release-candidates trên Discord.

Cuối cùng, có kênh dev, kênh này liên kết Unbloarchy trực tiếp với một bản checkout git của mã nguồn trong `~/unbloarchy`, kết hợp với các gói edge. Bạn chỉ nên sử dụng kênh này nếu bạn là người dùng Linux có kinh nghiệm, đang trực tiếp làm việc trên Unbloarchy, và sẵn sàng chấp nhận hỏng hóc.

Bạn có thể chuyển đổi giữa các kênh bằng _Cập nhật > Kênh_ từ menu Unbloarchy (hoặc `unbloarchy-channel-set` trong terminal).

### Chuyển đổi kernel

Unbloarchy khởi động kernel `linux-omarchy` của riêng mình, nhưng bạn có thể giữ các kernel khác được cài đặt bên cạnh nó, như kernel Arch gốc `linux` hoặc một bản dựng thử nghiệm mà bạn đang kiểm tra. Khi có nhiều hơn một kernel, _Cập nhật > Kernel_ trong menu Unbloarchy sẽ liệt kê chúng với một dấu kiểm bên cạnh kernel khởi động theo mặc định. Chọn một kernel khác, nhập mật khẩu của bạn một lần, và nó sẽ khởi động sau lần khởi động lại tiếp theo. Các kernel khác vẫn ở trong menu khởi động, vì vậy bạn vẫn có thể tự chọn một kernel bằng tay nếu kernel mặc định mới gây rắc rối cho bạn. Trong terminal, đó là `unbloarchy-kernel` để xem kernel mặc định hiện tại, `unbloarchy-kernel list` để xem những gì đã được cài đặt, và `unbloarchy-kernel set <kernel>` để chuyển đổi.

### Cập nhật firmware

Các gói của bạn không phải là thứ duy nhất trở nên lỗi thời. Nhiều laptop và thiết bị ngoại vi cung cấp firmware BIOS, SSD và dock thông qua Linux Vendor Firmware Service, và _Cập nhật > Firmware_ trong menu Unbloarchy sẽ tải về và cài đặt bất cứ thứ gì phần cứng của bạn đang chờ. Nó sẽ cài đặt `fwupd` trong lần đầu tiên bạn chạy nó. Rất nhiều firmware chỉ có thể được ghi trong lúc khởi động lại, vì vậy đừng ngạc nhiên nếu bạn được yêu cầu khởi động lại.

### Cảnh báo về việc cập nhật trực tiếp bằng pacman/yay

Nếu bạn đã quen thuộc với Arch, bạn có thể bị cám dỗ chỉ chạy `pacman -Syu` hoặc `yay -Syu` tự mình, nhưng nếu bạn làm vậy, bạn sẽ bỏ lỡ snapshot, các quá trình di chuyển và các bản cập nhật cấu hình mà Unbloarchy chạy cùng với các gói mới. Đó là lý do Unbloarchy thực sự sẽ chặn một lần nâng cấp hệ thống trực tiếp và chỉ bạn đến `unbloarchy update` thay thế. (Nếu bạn thực sự biết mình đang làm gì, lớp bảo vệ sẽ cho bạn biết cách bỏ qua nó cho một giao dịch duy nhất.)

### Khôi phục sau một bản cập nhật lỗi

Nếu bạn từng gặp sự cố sau khi thực hiện một bản cập nhật, bạn có thể khôi phục hệ thống của mình về snapshot được chụp trước khi cập nhật. Chỉ cần khởi động lại và chọn snapshot trong menu tải khởi động từ trước khi bạn bắt đầu cập nhật.

![bootloader](images/bootloader.webp)

Nếu bằng cách nào đó các tệp cấu hình của bạn đã bị hỏng, bạn cũng có thể thực hiện cài đặt lại Unbloarchy bằng `unbloarchy reinstall` trong terminal. Điều này sẽ cài đặt lại tất cả các gói Unbloarchy mặc định, đặt bạn trên kênh stable và hạ cấp mọi gói quá mới, và đặt lại tất cả các tệp cấu hình. Lưu ý rằng tất cả các thay đổi cấu hình người dùng của bạn đối với các mặc định của Unbloarchy sẽ bị ghi đè khi làm điều này!
