# Acesso remoto

Ligar de longe só serve se a pessoa conseguir entrar depois. O PC liga e para na **tela de login**, sem ninguém na frente. O app de acesso remoto precisa de duas coisas:
1. rodar como **serviço**, iniciando com o Windows antes do login (o app **instalado**, não só "executado");
2. ter uma **senha de acesso sem ninguém na frente** ("acesso não supervisionado", "unattended access", "senha permanente").

Pela tela de login, a pessoa digita o PIN ou a senha do Windows pelo próprio acesso remoto. **Antes de sair de casa, confirme que ela sabe esse PIN ou essa senha.** Quem entra com rosto ou digital muitas vezes não sabe.

## Conferir
- O diagnóstico lista os serviços de acesso remoto e se iniciam sozinhos ("Auto"). No AnyDesk, diz também se a senha de acesso sem ninguém está configurada, e avisa se ele está aberto sem estar instalado.
- Prova de que o serviço sobe antes do login:
  ```powershell
  Get-Process AnyDesk | Select-Object Id, SessionId, StartTime
  ```
  O processo da **sessão 0** é o serviço. No teste real, ele subiu 13 s depois do boot, quase 2 minutos antes do login. O da sessão 1 (o ícone na bandeja) só aparece depois do login. Por isso, olhando a tela de login, a pessoa pode achar que "o AnyDesk não abriu".

## AnyDesk aberto sem instalar
No AnyDesk aberto: menu → "Instalar AnyDesk neste computador" (ou o botão "Instalar" na tela inicial). Depois: Configurações → Segurança → "Acesso não supervisionado" → definir a senha. A instalação pede administrador; é ela quem aprova.

## Se ela não tem um app
Explique as opções e deixe que ela escolha; instalar só com o "sim":
- **AnyDesk / TeamViewer:** simples, funcionam pela internet sem configurar o roteador. Na instalação, escolher "instalar" (não só "executar") e configurar o acesso sem ninguém. O uso pessoal é grátis, com limites que mudam: confira.
- **RustDesk:** código aberto, grátis. Instalar como serviço.
- **Chrome Remote Desktop:** grátis, conta Google, funciona na tela de login.
- **Área de Trabalho Remota do Windows:** só o Windows **Pro** recebe conexão. De fora, só por VPN (Tailscale, ZeroTier); nunca abrindo a porta 3389 no roteador.

## Segurança (diga uma vez, curto)
O PC passa a aceitar conexões sem ninguém na frente. Então:
- senha de acesso **forte e só para isso**, diferente das outras;
- verificação em duas etapas, onde o app tiver;
- nunca passar o ID ou a senha para quem ligar dizendo ser "suporte" (golpe comum);
- se o app permitir, limitar quem pode conectar (lista de IDs ou conta).

## Depois de ligar
- Esperar cerca de 1 minuto antes de conectar: o Windows sobe e o serviço se conecta.
- Se o PC acordou da **suspensão** pela rede e ninguém usar, o Windows volta a dormir em uns 2 minutos. Se não conseguir conectar, toque em Ligar de novo e conecte logo.
- Notebook: com a tampa fechada, "Ao fechar a tampa" precisa estar em "Não fazer nada" quando na tomada; senão, ele suspende de novo.
