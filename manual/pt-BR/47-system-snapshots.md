# Snapshots do sistema

Criamos snapshots automaticamente a cada atualização do Unbloarchy, mas se você quiser criar o seu próprio, pode usar `unbloarchy-snapshot create`.

Para inicializar e restaurar um snapshot, você o seleciona no gerenciador de inicialização Limine. (Se no momento você está inicializando direto para a tela de descriptografia do Unbloarchy, primeiro vai precisar selecionar o Limine como opção de inicialização pela BIOS).

Nessa tela, escolha o snapshot que você quer inicializar com base na data e na versão. A versão do Unbloarchy na época do snapshot pode ser vista no canto inferior esquerdo.

 ![snapshots-bootloader](images/snapshots-bootloader.webp)

Quando você entrar, uma notificação vai aparecer avisando que você está em um snapshot inicializável e, se você clicar nela, o processo de restauração vai começar. Como alternativa, você pode usar `unbloarchy-snapshot restore`.

 ![snapshots-restore](images/snapshots-restore.webp)

Isso vai restaurar seu sistema de arquivos raiz, mas não seu `/home`. Então funciona para reverter uma atualização do sistema que quebrou, mas não para recuperar arquivos pessoais perdidos.

Isso também significa que seu diretório `~/.config` é mantido como está. Então, se você estiver voltando para uma versão anterior de uma biblioteca ou aplicativo que armazena arquivos de configuração em um novo formato, vai ter que resolver isso manualmente.

O mesmo vale para o próprio registro do Unbloarchy de quais migrações já foram executadas: ele fica no seu diretório home, então sobrevive à restauração. Migrações que foram executadas depois que o snapshot foi criado continuam marcadas como concluídas, mesmo que as alterações que elas fizeram no sistema de arquivos raiz tenham sido revertidas, e a próxima `unbloarchy update` não vai executá-las de novo. Então, se você atualizar de novo depois de uma restauração e algo que uma atualização anterior tinha configurado ainda estiver faltando, esse é o motivo provável.

_Nota: Este recurso só está disponível em instalações usando o gerenciador de inicialização Limine, que é o padrão desde o Unbloarchy 2.0. Não está disponível se você estiver no GRUB ou no systemd-boot._

### Pulando o menu de inicialização

Se você nunca mexe no menu de inicialização e só quer que a máquina vá direto para a tela de descriptografia, execute _Setup > Direct Boot_ no menu do Unbloarchy. Isso adiciona uma entrada EFI apontando diretamente para o Unbloarchy, então o firmware inicializa nele sem parar no Limine.

A contrapartida é a mencionada no início: com a inicialização direta ativada, chegar a um snapshot significa primeiro escolher o Limine no menu de inicialização da sua BIOS. Execute _Setup > Direct Boot_ de novo para remover a entrada e voltar a inicializar pelo Limine. Alguns firmwares não lidam bem com entradas EFI personalizadas, então a configuração se recusa a ser executada em firmwares American Megatrends e Apple.
