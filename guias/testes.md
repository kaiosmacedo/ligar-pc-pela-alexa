# Testes em casa

Antes da Alexa, prove que a placa liga o PC, com um app de Wake-on-LAN no celular. Se falhar aqui, falharia com a Alexa também, e daqui é muito mais fácil descobrir por quê.

## O app no celular
- **Android:** o WolOn (desenvolvedor Darkside Dev) estava atualizado e bem avaliado em nov/2026. O "Wake On Lan" da MR-Webb, famoso, não instala mais em Android novo. Confira na loja na hora: data da última atualização, nota e se instala no aparelho dela.
- **iPhone:** procure um app de Wake-on-LAN atualizado na App Store. O iOS pede a permissão **Rede Local**: aceite quando o app pedir, ou ligue em Ajustes → Privacidade e Segurança → Rede Local → o app. Sem ela, o app mostra o envio e nada sai do celular.
- Celular **no Wi‑Fi de casa** durante os testes.

## Configurar
| Campo | O que pôr |
|---|---|
| Modo | **LAN** (WAN é pela internet, e não é o caminho aqui) |
| MAC | o da placa com cabo (o diagnóstico mostra com hífens e com dois-pontos) |
| Broadcast / endereço de envio | o **broadcast** do diagnóstico (ex.: `192.168.0.255`). **Nunca o IP do PC** |
| Porta | `9` |
| Host do ping | opcional: o IP do PC. Só mostra se ele está ligado |
| Porta do ping | deixe como está |
| Senha SecureOn | **em branco** |

**A armadilha que mais custou no teste real:** com o IP do PC no lugar do broadcast, o pacote chega com o PC ligado, mas se perde com ele suspenso ou desligado. A tela do app mostra a animação de envio do mesmo jeito. Se a suspensão não acordar, confira isto antes de tudo.

## Os três testes (um de cada vez; se um falhar, pare)
Antes de cada um, grave no `progresso.md` qual teste vem e o que fazer se falhar. A conversa para enquanto o PC está desligado.

1. **Suspensão:** Iniciar → Energia → Suspender. Esperar 1 minuto. Tocar no PC no app.
2. **Desligado:** Iniciar → Energia → **Desligar** (o desligar do dia a dia; o comando `shutdown /s` desliga por completo mesmo com a inicialização rápida ligada e esconderia o problema). Esperar 1 minuto. Tocar no PC no app.
3. **Depois de falta de luz:** desligar, tirar da tomada (ou desligar a chave da fonte) por 30 segundos, ligar de volta **sem apertar o botão**. Tocar no PC no app. Algumas placas só voltam a aceitar o pacote depois que o PC liga uma vez; este teste mostra se é o caso. Obrigatório onde falta luz.

## Como confirmar
- **O que vale é a pessoa ver o PC ligar sem tocar nele.**
- Os registros do Windows ajudam pouco: em placas AMD, a volta da suspensão pela rede costuma aparecer como "Botão de Energia" ou "Unknown" (`powercfg /lastwake`, evento 1 do Power-Troubleshooter), e o "tipo de despertar" da BIOS (`Win32_ComputerSystem.WakeUpType`) pode dizer "botão" sempre. Não diga que falhou ou passou só por eles.

## Quando não liga
1. **O pacote chega no PC?** Com o PC ligado, rode o `scripts/escutar-wol.ps1` (pede administrador; escuta as portas 9 e 7) e toque no PC no app enquanto ele escuta:
   ```powershell
   Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "<caminho completo>\escutar-wol.ps1"'
   ```
   O resultado fica em `C:\Users\Public\Documents\escutar-wol.txt`; leia de lá.
   - **A escuta não rodou:** o script diz. Isso não é resultado; corrija e repita.
   - **Nada chegou:** celular fora do Wi‑Fi de casa ou na rede de visitantes, app em WAN, porta ou MAC errados. Alguns roteadores isolam o Wi‑Fi do cabo ("isolamento de clientes", "AP isolation"): procure na página do roteador.
   - **Chegou, mas direto para o IP do PC:** troque para o broadcast (acima).
   - **Chegou para a rede inteira e mesmo assim não liga:** o problema está no PC → próximo item.
2. **No PC:**
   - luzes do conector de rede **acesas com o PC desligado**? Apagadas = a placa está sem energia: ErP ligado, Wake-on-LAN desligado na BIOS, ou fonte e tomada sem energia;
   - inicialização rápida e opções da placa (`windows.md`); rode o diagnóstico;
   - desligue, um por vez, `*EEE`, `EnableGreenEthernet` e `PowerSavingMode`, testando depois de cada um;
   - driver do fabricante no lugar do genérico do Windows Update;
   - atualização de BIOS, só se o fabricante citar Wake-on-LAN nas notas da versão. Antes, a pessoa guarda a chave de recuperação do BitLocker (aka.ms/myrecoverykey): com a criptografia do dispositivo ligada, comum no Windows 11, a atualização pode pedir a chave no boot. Ela faz a atualização seguindo o manual da placa.
3. Se só o teste 3 falha (depois da falta de luz), procure na BIOS uma opção de Wake-on-LAN depois de queda de energia ("PME from G3", "Wake on LAN after power loss"). Sem ela, o PC só aceita o pacote depois de ligar uma vez.

## Depois de pronto
Atualizações grandes do Windows e trocas de driver às vezes religam a inicialização rápida ou desmarcam as opções da placa. Se um dia parar de ligar, rode o diagnóstico antes de tudo.
