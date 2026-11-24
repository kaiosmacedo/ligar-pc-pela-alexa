# Caminhos para ligar o PC de longe

O PC desligado não tem Windows rodando: nada nele recebe comando pela internet. O que pode ligá-lo é a **placa de rede**, que fica com um fio de energia esperando um "pacote mágico" com o MAC dela (Wake-on-LAN), ou a **própria energia voltando** (opção da BIOS). Todo caminho é um jeito de fazer uma dessas duas coisas acontecer de longe.

## 1. Skill da Alexa com o Echo (o padrão)
O app da Alexa manda o comando para a nuvem da Amazon, que pede ao Echo de casa para mandar o pacote mágico na rede local. É uma função oficial da Alexa (Wake-on-LAN Controller), usada por skills que cadastram o PC.
- **Prós:** grátis, nada a comprar, não mexe no roteador, funciona de qualquer lugar e por voz, o PC aparece como um dispositivo no app da Alexa.
- **Contras:** depende de o Wake-on-LAN funcionar no PC e de uma skill de terceiro (pode mudar de plano ou sair da loja; tenha uma reserva).
- **Precisa:** PC com cabo de rede; um Echo (Echo, Dot, Show, Pop…) **na mesma rede**, no Wi‑Fi principal, não no de visitantes.
- O Echo manda o pacote para a rede inteira (broadcast). Por isso este caminho não sofre a armadilha do "app mandando para o IP" descrita em `testes.md`.

## 2. Tomada inteligente + "ligar quando a energia voltar" (a reserva)
A BIOS tem uma opção que liga o PC sempre que a energia volta. Uma tomada inteligente com Alexa corta e devolve a energia.
- **Prós:** funciona sem cabo de rede e em PC cujo Wake-on-LAN falha.
- **Contras:** custa a tomada. **Se falta luz na casa, o PC liga sozinho toda vez que a luz volta**, a não ser que a tomada tenha a opção "estado depois de queda de energia: desligada" (confira antes de comprar). Desligar a tomada com o PC ligado corta a energia de vez, como puxar o fio.
- **Notebook:** só serve se a BIOS tiver a opção de ligar quando o carregador é conectado ("Wake on AC" na Dell, "Power On with AC Attach" nos ThinkPad, "After Power Loss" na HP). Confira na BIOS **antes** de comprar a tomada. A bateria precisa estar acima do mínimo que a BIOS exige.

### Roteiro da tomada (substitui as fases 3 a 6)
1. **Escolher a tomada:** com Alexa, com "estado depois de queda de energia" configurável e com potência acima da fonte do PC.
2. **BIOS:** Restore on AC Power Loss = **Power On** (notebook: a opção equivalente acima). O resto da BIOS (ErP, Wake on LAN) não importa neste caminho.
3. **Windows:** nada de rede. No notebook, "Ao fechar a tampa: Não fazer nada" quando na tomada.
4. **Tomada:** no app dela, estado depois de queda = **desligada**; ligar à Alexa e dar um nome ("tomada do PC").
5. **Teste em casa:** desligar o PC pelo Windows → tomada desliga → espera 10 s → tomada liga → o PC liga sozinho.
6. **Dia a dia:** ligar = desligar e religar a tomada pela Alexa. Desligar = sempre pelo Windows (ou acesso remoto) e só depois a tomada.
7. Seguir para as fases 7 e 8 (acesso remoto e teste de fora).

## 3. Celular por VPN (Tailscale, ZeroTier) sem Alexa
O pacote mágico não atravessa a VPN até um PC desligado: o PC desligado não está na VPN. Funciona só com **outro aparelho sempre ligado em casa** que repasse o pacote (Raspberry Pi, um Android velho, um NAS, um roteador com essa função).
- Serve para quem já tem esse aparelho. Não usa a Alexa.

## 4. Pela internet, abrindo porta no roteador
Mandar o pacote de fora para o IP de casa, com a porta 9 apontando para o PC.
- **Evite.** Minutos depois que o PC desliga, o roteador esquece o endereço dele e o pacote se perde. Muitas operadoras usam CGNAT (vários clientes no mesmo IP público), e aí a porta nem chega. Alguns roteadores têm um botão de Wake-on-LAN na página de administração: ajuda dentro de casa, raramente de fora.

## Como recomendar
- Cabo + Echo na mesma rede → caminho 1.
- Desktop sem cabo: passar um cabo é o melhor; se não der, caminho 2.
- Notebook: com cabo na placa de rede **própria** do notebook, teste o caminho 1 (fase 5). Adaptador de rede USB raramente liga o PC a partir do desligado. Só Wi‑Fi → caminho 2, se a BIOS tiver a opção.
- Sem Echo → caminho 2, ou caminho 3 se já existe um aparelho sempre ligado.
