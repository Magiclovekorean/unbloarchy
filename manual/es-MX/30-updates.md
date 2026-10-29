# Actualizaciones

Unbloarchy y tus paquetes se mantienen actualizados mediante _Actualizar > Unbloarchy_ en el menú de Unbloarchy (`Super + Space`).

Unbloarchy en sí se instala como paquetes normales de pacman desde el [Repositorio de paquetes de Unbloarchy](https://github.com/omacom-io/omarchy-pkgs), así que una actualización instala [la última versión de Unbloarchy](https://github.com/omacom/omarchy/releases), ejecuta las migraciones pendientes para sincronizar tu sistema con la versión más reciente y actualiza todos los paquetes del sistema desde el [Mirror de Arch de Unbloarchy](https://github.com/omacom-io/omarchy-mirror) y [AUR](https://aur.archlinux.org/) (si has instalado algún paquete de AUR).

Cuando se publican nuevas versiones, aparecerá un icono de flecha circular a la derecha de tu reloj. Haz clic en él y comenzará el proceso de actualización.

![update-available](images/update-available.webp)

### Cuatro canales

Unbloarchy se actualiza a través de cuatro canales: stable, RC, edge y dev. Las instalaciones nuevas comienzan en el canal stable, que sigue las [versiones oficiales](https://github.com/omacom/omarchy/releases/), así como el [mirror estable de Arch de Unbloarchy](https://github.com/omacom-io/omarchy-mirror) que va un mes por detrás de lo más reciente, para que podamos detectar cualquier incompatibilidad nueva que requiera cambios de configuración antes de que cause problemas a la gente.

Pero si quieres ayudar a detectar esos posibles problemas, puedes usar el canal edge. Eso hará que tus paquetes de Unbloarchy sigan las compilaciones de desarrollo más recientes y te permitirá actualizar a los paquetes más recientes de Arch en cuanto estén disponibles. Solo deberías hacer esto si tienes experiencia con Linux y sabes cómo recuperar un sistema que tiene problemas.

Antes de cada nueva versión mayor, haremos la validación final usando el canal RC. Si te interesa ayudar con los últimos retoques, pásate por #unbloarchy-release-candidates en Discord.

Por último, está el canal dev, que vincula Unbloarchy directamente a una copia del código fuente obtenida con git en `~/unbloarchy`, combinada con los paquetes edge. Solo deberías usar este canal si eres un usuario experimentado de Linux, trabajas directamente en Unbloarchy y estás dispuesto a tolerar que algo se rompa.

Puedes cambiar entre canales usando _Actualizar > Canal_ desde el menú de Unbloarchy (o `unbloarchy-channel-set` en la terminal).

### Cambiar de kernel

Unbloarchy arranca con su propio kernel `linux-omarchy`, pero puedes mantener otros instalados junto a él, como el kernel `linux` estándar de Arch o una compilación experimental que estés probando. Cuando hay más de uno, _Actualizar > Kernel_ en el menú de Unbloarchy los enumera con una marca junto al que arranca por defecto. Elige otro, ingresa tu contraseña una vez y arrancará después del próximo reinicio. Los demás kernels permanecen en el menú de arranque, así que aún puedes elegir uno manualmente si el nuevo predeterminado te da problemas. En la terminal, es `unbloarchy-kernel` para ver el predeterminado actual, `unbloarchy-kernel list` para ver qué está instalado y `unbloarchy-kernel set <kernel>` para cambiar.

### Actualizaciones de firmware

Tus paquetes no son lo único que se queda obsoleto. Muchas laptops y periféricos distribuyen firmware de BIOS, SSD y dock a través del Linux Vendor Firmware Service, y _Actualizar > Firmware_ en el menú de Unbloarchy descargará e instalará lo que tu hardware tenga pendiente. Instala `fwupd` la primera vez que lo ejecutas. Gran parte del firmware solo se puede escribir durante un reinicio, así que no te sorprendas si te pide uno.

### Advertencia sobre las actualizaciones directas con pacman/yay

Si ya conoces Arch, podrías sentir la tentación de ejecutar simplemente `pacman -Syu` o `yay -Syu` por tu cuenta, pero si lo haces, te perderás la instantánea, las migraciones y las actualizaciones de configuración que Unbloarchy ejecuta junto con los paquetes nuevos. Por eso Unbloarchy en realidad detendrá una actualización directa del sistema y te indicará que uses `unbloarchy update` en su lugar. (Si de verdad sabes lo que estás haciendo, la protección te dirá cómo omitirla para una sola transacción).

### Revertir actualizaciones problemáticas

Si alguna vez tienes un problema después de hacer una actualización, puedes revertir tu sistema a la instantánea tomada antes de la actualización. Solo reinicia y elige en el menú de arranque la instantánea de antes de que comenzaras la actualización.

![bootloader](images/bootloader.webp)

Si por alguna razón tus archivos de configuración se han dañado, también puedes realizar una reinstalación de Unbloarchy usando `unbloarchy reinstall` en la terminal. Esto reinstalará todos los paquetes predeterminados de Unbloarchy, te pondrá en stable y bajará de versión cualquier paquete que sea demasiado nuevo, y restablecerá todos los archivos de configuración. ¡Ten en cuenta que al hacer esto se sobrescribirán todos los cambios de configuración de usuario que hayas hecho a los valores predeterminados de Unbloarchy!
