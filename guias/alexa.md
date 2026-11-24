# Alexa

A skill cadastra o PC como um dispositivo com a função oficial de Wake-on-LAN da Alexa. Quando a pessoa toca em Ligar (ou fala), a Amazon pede ao Echo de casa para enviar o pacote mágico para o MAC cadastrado, para a rede inteira.

## O Echo precisa estar na mesma rede do PC
- Conferir: app da Alexa → Dispositivos → Echo e Alexa → o Echo → Status/Configurações → **Rede Wi‑Fi**. Tem que ser a rede principal de casa, a mesma do roteador em que o PC está ligado; não a de visitantes, nem a de um repetidor com rede separada.
- Trocar: na mesma tela, "Alterar" e escolher a rede principal.
- Há relatos de falha com o Echo ligado por cabo no adaptador da Amazon; pelo Wi‑Fi funciona.

## Escolher a skill
Opções que funcionavam no Brasil em nov/2026, em português e do mesmo jeito:
- **SayBoot:** grátis até 2 PCs, nota alta nas avaliações brasileiras. Tem um programa para Windows (loja da Microsoft) que cadastra o PC sozinho e permite desligar pela Alexa.
- **RemoteRelay** (antiga "Wake on Lan (WoL)", ou WOLSkill): grátis para 1 PC; avaliações mais baixas por problemas de vínculo de conta depois de uma mudança.

Antes de recomendar, confira na loja de skills da Alexa do país dela: se ainda existe, se o plano grátis cobre ligar, as avaliações recentes e se fala a língua dela. Tenha a outra como reserva: se uma não vincular, a outra faz o mesmo.

## Passo a passo (SayBoot; outras são parecidas)
1. No site da skill, entrar com a conta Amazon da Alexa.
2. O site pede para instalar o programa do Windows pela loja da Microsoft. Explique que ele é o jeito normal de cadastrar o PC (manda o MAC sozinho) e que também serve para desligar pela voz. Instalar só com o "sim" dela.
3. O programa abre o navegador numa página de autorização: ela autoriza.
4. **Conferir os MACs no painel da skill.** O programa cadastra todos os MACs do PC (cabo, Wi‑Fi, Bluetooth) e pode pôr o do **Wi‑Fi como principal** (aconteceu no teste real). O painel da SayBoot diz que manda para todos, mas deixe o da placa com cabo como principal ("tornar principal" e salvar): é o único que liga o PC, e não dá para conferir daqui o que a skill manda.
5. Ativar a skill no app da Alexa e vincular a mesma conta (o painel costuma mostrar um QR code para isso).
6. Se o painel continuar dizendo "Alexa não vinculada", recarregue a página. Se persistir: app da Alexa → Mais → Skills e jogos → Suas skills → a skill → Vincular conta.
7. No app da Alexa, em Dispositivos, o PC aparece com um botão de ligar. Se não aparecer: Dispositivos → + → Adicionar dispositivo → Outro → Descobrir.
8. Teste em casa: PC desligado, app da Alexa → o PC → Ligar.

Páginas abertas no navegador da pessoa você só consegue ver (navegador por controle de tela costuma ser só leitura). Veja a tela ou peça um print, e diga onde clicar.

## Quando a Alexa responde e o PC não liga
1. O teste com o app do celular (fase 5) passa? Se não passa, o problema está no PC.
2. O MAC principal é o do cabo?
3. **O pacote do Echo chega no PC?** Com o PC ligado, rode o `escutar-wol.ps1` (ver `testes.md`) e toque em Ligar no app da Alexa enquanto ele escuta. Aparecer o IP do Echo como origem prova que o Echo está na mesma rede e envia. Não chegar nada = Echo em outra rede, isolamento no roteador ou skill sem vínculo.
4. Echo muito antigo ou fora da lista da Amazon: teste com outro, se houver.

## Depois de pronto
- Trocou o **roteador**: em geral nada muda (o MAC é da placa). Se o Echo e o PC ficarem em redes diferentes, para de funcionar.
- Trocou a **placa de rede ou a placa-mãe**: o MAC muda. Atualize na skill.
- Trocou o **Echo**: o novo precisa estar na mesma conta e na mesma rede.
