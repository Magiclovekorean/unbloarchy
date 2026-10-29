# Atualizações

O Unbloarchy e os seus pacotes são mantidos atualizados por meio de _Atualizar > Unbloarchy_ no menu do Unbloarchy (`Super + Space`).

O próprio Unbloarchy é instalado como pacotes comuns do pacman a partir do [Repositório de Pacotes do Unbloarchy](https://github.com/omacom-io/omarchy-pkgs), portanto uma atualização instala [a versão mais recente do Unbloarchy](https://github.com/omacom/omarchy/releases), executa todas as migrações pendentes para deixar seu sistema em sincronia com a versão mais recente e atualiza todos os pacotes do sistema a partir do [Espelho Arch do Unbloarchy](https://github.com/omacom-io/omarchy-mirror) e da [AUR](https://aur.archlinux.org/) (se você tiver instalado algum pacote da AUR).

Quando novas versões forem lançadas, um ícone de seta circular aparecerá à direita do seu relógio. Clique nele e o processo de atualização será iniciado.

![update-available](images/update-available.webp)

### Quatro canais

O Unbloarchy é atualizado por meio de quatro canais: stable, RC, edge e dev. Novas instalações começam no canal stable, que acompanha as [versões oficiais](https://github.com/omacom/omarchy/releases/), bem como o [espelho Arch estável do Unbloarchy](https://github.com/omacom-io/omarchy-mirror) que funciona com um mês de atraso em relação à versão mais recente, para que possamos detectar quaisquer novas incompatibilidades que exijam mudanças de configuração antes que elas causem problemas para as pessoas.

Mas, se você quiser ajudar a detectar esses possíveis problemas, pode usar o canal edge. Isso manterá seus pacotes do Unbloarchy acompanhando as compilações de desenvolvimento mais recentes e permitirá atualizar para os pacotes mais recentes do Arch assim que eles estiverem disponíveis. Você só deve fazer isso se tiver experiência com Linux e souber como recuperar um sistema que apresente problemas.

Antes de qualquer nova versão principal, faremos a validação final usando o canal RC. Se você tiver interesse em ajudar no polimento final, venha participar de #unbloarchy-release-candidates no Discord.

Por fim, há o canal dev, que vincula o Unbloarchy diretamente a um checkout git do código-fonte em `~/unbloarchy`, combinado com os pacotes edge. Você só deve usar esse canal se for um usuário experiente de Linux, estiver trabalhando diretamente no Unbloarchy e estiver disposto a tolerar quebras.

Você pode alternar entre canais usando _Atualizar > Canal_ no menu do Unbloarchy (ou `unbloarchy-channel-set` no terminal).

### Trocando de kernel

O Unbloarchy inicializa com seu próprio kernel `linux-omarchy`, mas você pode manter outros instalados ao lado dele, como o kernel `linux` padrão do Arch ou uma compilação experimental que você esteja testando. Quando houver mais de um, _Atualizar > Kernel_ no menu do Unbloarchy os lista com uma marca de seleção ao lado daquele que inicializa por padrão. Escolha outro, digite sua senha uma vez e ele inicializará após a próxima reinicialização. Os outros kernels permanecem no menu de inicialização, portanto você ainda poderá escolher um manualmente se o novo padrão lhe causar problemas. No terminal, use `unbloarchy-kernel` para ver o padrão atual, `unbloarchy-kernel list` para ver o que está instalado e `unbloarchy-kernel set <kernel>` para trocar.

### Atualizações de firmware

Seus pacotes não são a única coisa que fica desatualizada. Muitos laptops e periféricos distribuem firmware de BIOS, SSD e dock por meio do Linux Vendor Firmware Service, e _Atualizar > Firmware_ no menu do Unbloarchy buscará e instalará tudo o que seu hardware tiver aguardando. Ele instala o `fwupd` na primeira vez que você o executa. Muitos firmwares só podem ser gravados durante uma reinicialização, portanto não se surpreenda se uma for solicitada.

### Aviso sobre atualizações diretas com pacman/yay

Se você já está familiarizado com o Arch, pode ficar tentado a simplesmente executar `pacman -Syu` ou `yay -Syu` por conta própria, mas, se fizer isso, perderá o snapshot, as migrações e as atualizações de configuração que o Unbloarchy executa junto com os novos pacotes. É por isso que o Unbloarchy realmente interromperá uma atualização direta do sistema e o direcionará para `unbloarchy update`. (Se você realmente sabe o que está fazendo, a proteção informará como ignorá-la em uma única transação.)

### Revertendo atualizações problemáticas

Se você tiver qualquer problema depois de fazer uma atualização, poderá reverter seu sistema para o snapshot tirado antes da atualização. Basta reiniciar e escolher no menu de inicialização o snapshot de antes de você iniciar a atualização.

![bootloader](images/bootloader.webp)

Se, de alguma forma, seus arquivos de configuração tiverem sido corrompidos, você também poderá realizar uma reinstalação do Unbloarchy usando `unbloarchy reinstall` no terminal. Isso reinstalará todos os pacotes padrão do Unbloarchy, colocará você no canal stable e fará downgrade de quaisquer pacotes que forem novos demais, além de redefinir todos os arquivos de configuração. Observe que todas as alterações feitas por você nas configurações padrão do Unbloarchy serão sobrescritas ao fazer isso!
