# BIOS

Na BIOS, esta conversa para (o Windows não está rodando). A pessoa leva o roteiro no celular e conversa com o Claude por lá. Prepare tudo antes de reiniciar, e grave o `progresso.md` com o próximo passo antes de dar o comando.

## O que mudar
1. **ErP** = Disabled. Com ErP ligado, a placa de rede fica sem energia com o PC desligado e nada a acorda. Nomes: "ErP", "ErP Ready", "EuP", "Deep Sleep", "Deep S4/S5", "Deep Sleep Control" (Dell), "Energy Star".
2. **Wake on LAN** = Enabled. Nomes: "Wake on LAN", "Power On By PCI-E", "Resume by PCI-E Device", "PCIE Devices Power On", "Wake On PME", "Resume by LAN", "Remote Wake Up".
3. **Restore on AC Power Loss** (o que o PC faz quando a energia volta):
   - caminho do Echo: **Power Off**, sempre. Com "Power On", o PC liga sozinho a cada volta da luz, e o Wake-on-LAN não precisa disso;
   - caminho da tomada: **Power On** (num notebook, a opção equivalente: "Wake on AC", "Power On with AC Attach").
4. **Salvar e sair:** F10 na maioria; em algumas BIOS, um botão na tela ("Save & Exit", "Apply Changes" na Dell).

Não junte outras mudanças nesta visita. Desligar o vídeo integrado, mexer em memória ou tensão: cada uma tem seus riscos (sem imagem, PC que não liga), e misturar atrapalha descobrir o que deu errado.

## Onde costuma ficar, por marca
Ponto de partida, não verdade: os menus mudam com o modelo e a versão. Pesquise "<modelo da placa> wake on lan bios" antes e ponha no roteiro o que achar.

| Marca | Antes de tudo | ErP | Wake on LAN | Energia volta |
|---|---|---|---|---|
| ASUS | **F7** abre o modo avançado (a BIOS abre no EZ Mode) | Advanced → APM Configuration → ErP Ready | APM Configuration → Power On By PCI-E | APM Configuration → Restore AC Power Loss |
| Gigabyte | F2 alterna o modo fácil e o avançado | Settings → Platform Power → ErP | Platform Power → Wake on LAN | Platform Power → AC BACK |
| MSI | F7 alterna o modo fácil e o avançado | Settings → Advanced → Power Management Setup → ErP Ready | Advanced → Wake Up Event Setup → Resume By PCI-E Device | Power Management Setup → Restore after AC Power Loss |
| ASRock | F6 alterna o modo fácil e o avançado | Advanced → ACPI Configuration → Deep Sleep | ACPI Configuration → PCIE Devices Power On | Advanced → Chipset Configuration → Restore on AC/Power Loss |
| AMI genérica (ex.: MAXSUN) | — | ErP / EuP | **Wake On PME** (testado numa MAXSUN B850M) | Restore AC Power Loss |
| Dell (notebook e desktop) | — | Power Management → Deep Sleep Control = Disabled | Power Management → Wake on LAN/WLAN = LAN Only | Power Management → Wake on AC / AC Recovery |
| Lenovo ThinkPad | — | — | Config → Network → Wake On LAN = AC only | Config → Power → Power On with AC Attach |
| HP | — | — | Advanced → Built-in Device Options → Wake On LAN | Advanced → Power-On Options → After Power Loss |

"Wake on USB" / "Wake On USB KB/MS" é para teclado e mouse: pode ficar como está.

## Entrar na BIOS
Comando que reinicia direto na BIOS (pede a aprovação de administrador; salvar o que estiver aberto antes):

```powershell
Start-Process shutdown -Verb RunAs -ArgumentList '/r /fw /t 5'
```

Se abrir o Windows em vez da BIOS: reiniciar e apertar várias vezes, logo ao ligar, Del ou F2 (a maioria dos desktops), F2 (Dell, ASUS de notebook), F1 (Lenovo) ou F10 (HP).

## A conversa no celular
- Use `modelos/roteiro-celular.md`. Preencha com a placa-mãe, a versão da BIOS, o processador, a tecla do modo avançado e os nomes prováveis (da tabela ou do que você pesquisou).
- O texto pede ao Claude do celular para ir **um passo por vez**, a partir de fotos da tela, e para **não mudar mais nada**.
- Se a pessoa travar: Esc → sair **sem salvar** ("Discard changes and exit"). Nada muda.

## Na volta
Pergunte o que ela encontrou: o nome real de cada opção, o valor que estava e o que ficou. Grave no `progresso.md`. Do Windows não dá para ler a BIOS: quem confirma é o teste da fase 5.
