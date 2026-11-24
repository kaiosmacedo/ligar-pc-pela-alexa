# Windows

Três coisas, nesta ordem. Depois, rode o diagnóstico de novo para conferir.

## 1. Gerenciamento de Energia da placa (a pessoa clica)
Gerenciador de Dispositivos (Win+X → Gerenciador de Dispositivos) → Adaptadores de rede → a placa **com cabo** (não a Wi‑Fi, não as virtuais de VPN) → Propriedades → aba **Gerenciamento de Energia**. Marcar as três (textos do Windows 11 em português):
- "O computador pode desligar o dispositivo para economizar energia" (sem ela, as outras ficam cinza);
- "Permitir que este dispositivo acorde o computador";
- "Somente permitir um pacote Magic para ativar o computador". Sem ela, qualquer tráfego da rede acorda o PC da suspensão.

Ler essas caixas pede administrador. O diagnóstico confere a segunda pelo `powercfg` ("Pode acordar o PC"). Na dúvida, peça um print.

## 2. Aba Avançado da placa
O diagnóstico lista as opções da aba Avançado. Os nomes mudam com o fabricante e com a tradução (uma Realtek mostrou "Pacote Wake on Magic", "Desligar Despertar Aquando de Lan"). Procure pela palavra-chave entre colchetes, que não muda:

| Palavra-chave | Valor | Para quê |
|---|---|---|
| `*WakeOnMagicPacket` | ligado | acordar com o pacote mágico (Realtek e Intel) |
| `S5WakeOnLan` (Realtek) | ligado | acordar a partir do **desligado** |
| `WolShutdownLinkSpeed` (Realtek) | "10 Mbps primeiro" serve | velocidade da rede com o PC desligado |
| `EnablePME` (Intel) | ligado | deixa a placa acordar o PC |
| `WakeOnLink` (Intel) | desligado | acordaria o PC só por o cabo ser conectado |
| "Wake on Magic Packet from power off state" (Intel, drivers antigos) | ligado | acordar a partir do desligado |
| `*WakeOnPattern` | tanto faz | "somente pacote Magic" já filtra |
| `*EEE`, `EnableGreenEthernet`, `PowerSavingMode`, `GigaLite` | deixe como está | só desligue um por vez se os testes falharem com tudo o mais certo |

Para outra marca (Killer, Marvell, Broadcom), procure as equivalentes na documentação do fabricante antes de sugerir.

Se as opções de Wake não aparecem, o driver pode ser o genérico do Windows Update. Sugira o driver do site do fabricante da placa-mãe ou da placa de rede, e explique antes.

## 3. Inicialização rápida (o motivo nº 1 de "não liga do desligado")
Com ela ligada, o "desligar" do Windows é meio hibernação, e muitas placas não armam o Wake-on-LAN. Comando (pede a aprovação de administrador):

```powershell
Start-Process reg -Verb RunAs -ArgumentList 'add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f'
```

Ou pelos cliques: Painel de Controle → Opções de Energia → Escolher a função dos botões de energia → Alterar configurações não disponíveis → desmarcar "Ligar inicialização rápida".

## Armadilhas
- **MAC errado:** o PC costuma ter várias placas (cabo, Wi‑Fi, Bluetooth, VPN). Só o MAC da placa com cabo serve. O diagnóstico mostra qual é e avisa se houver mais de uma com cabo.
- **Wi‑Fi:** Wake-on-LAN por Wi‑Fi quase nunca funciona com o PC desligado. Mesmo que a placa Wi‑Fi apareça em "pode acordar", não conte com ela.
- **Filtro de linha com chave, ou tomada desligada:** sem energia na fonte, nada liga. A fonte também precisa estar com a chave de trás ligada.
