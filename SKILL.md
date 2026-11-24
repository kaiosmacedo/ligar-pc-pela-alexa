---
name: ligar-pc-pela-alexa
description: "Guia a pessoa, passo a passo, a configurar o PC com Windows para ligar de longe pelo app ou pela voz da Alexa (Wake-on-LAN enviado pelo Echo), inclusive fora de casa, e a entrar nele depois por AnyDesk ou outro acesso remoto. Adapta tudo ao hardware dela: diagnóstico da placa de rede e da placa-mãe, ajustes do Windows, BIOS com uma conversa de apoio no celular, testes em casa, skill da Alexa e teste final pelo 4G. Use em /ligar-pc-pela-alexa e sempre que a pessoa quiser ligar o computador remotamente, pela Alexa, por Wake-on-LAN (WoL) ou pelo celular, ou perguntar por que o WoL não liga o PC."
---

# ligar-pc-pela-alexa

Você vai ajudar a pessoa a deixar o PC dela pronto para **ligar pelo app da Alexa, de qualquer lugar**, e para ela entrar nele de longe. Quem manda o "pacote mágico" que liga o PC é o próprio Echo, de dentro da casa. Por isso não é preciso abrir porta no roteador nem deixar outro aparelho ligado.

O roteiro foi testado do zero até funcionar num PC real: desktop AMD com placa de rede Realtek, roteador de operadora, Echo no Wi‑Fi, celular Android e AnyDesk. As armadilhas que apareceram estão nos guias. Outros PCs mudam os nomes da BIOS, a placa de rede e o app de acesso remoto. O caminho é o mesmo.

## Como falar
- Português, frases curtas, sem jargão sem explicar. Muita gente aqui nunca entrou na BIOS.
- Uma etapa por vez. Antes de cada uma, diga em uma frase o que ela faz e por quê.
- Uma pergunta por vez, sempre com a sua sugestão: "Eu sugiro X, porque Y. Prefere outra coisa?"
- **Comandos:** o que só lê (o diagnóstico, conferências), você roda. O que muda algo no PC, você explica antes, espera o "sim" e roda dentro de `Start-Process ... -Verb RunAs`: o Windows abre a janela de administrador, e quem aprova é a pessoa. Se ela preferir rodar sozinha, entregue o comando num bloco próprio, de uma linha, marcado como `powershell` (no app do Claude, esse bloco ganha um botão Executar; no terminal, ela copia e cola).
- **Quem muda as configurações é a pessoa:** BIOS, roteador, as contas dela e as caixas do Windows que são cliques. Você diagnostica, explica e dá o caminho dos cliques. Assim ela sabe o que mudou no PC dela.
- Ao dizer o que um teste mostra, separe o que você conferiu (comando, registro) do que a pessoa viu. Alguns registros do Windows mentem nesse assunto (ver `guias/testes.md`).

## Arquivos desta skill (leia só o que a fase pedir)
| Arquivo | Quando |
|---|---|
| `scripts/diagnostico.ps1` | Fase 1, e depois de cada mudança, para conferir. Só lê. |
| `guias/caminhos.md` | Fase 2: os caminhos possíveis e quando cada um serve |
| `guias/windows.md` | Fase 3 |
| `guias/bios.md` | Fase 4, com `modelos/roteiro-celular.md` |
| `guias/testes.md` | Fase 5, e sempre que algo não ligar. Usa `scripts/escutar-wol.ps1` |
| `guias/alexa.md` | Fase 6 |
| `guias/acesso-remoto.md` | Fase 7 |
| `modelos/progresso.md` | Sempre: o caderno de onde a configuração parou |

Os guias trazem **critérios e armadilhas**. Nome de app, preço, plano grátis e disponibilidade mudam: confira na hora, na loja do celular e na loja da Alexa do país da pessoa, antes de recomendar.

## Progresso (o PC reinicia várias vezes no caminho)
O caderno fica em `~/ligar-pc-pela-alexa/progresso.md` (modelo em `modelos/progresso.md`). Grave nele ao fim de cada fase, e **antes de todo reinício, suspensão ou desligamento**, com o próximo passo escrito: o hardware, as escolhas, o resultado de cada teste. Os reinícios caem no meio das fases 4 e 5; se a conversa se perder num deles, uma conversa nova continua de onde parou.

Ao abrir esta skill:
1. Procure o `progresso.md`. Se existir, diga em 3 a 5 linhas onde parou e siga de lá.
2. Se não existir, comece pela fase 0.

## Fase 0. Apresentar
Diga em poucas linhas:
- o resultado: tocar num botão do app da Alexa (ou falar "Alexa, liga o computador"), o PC liga, e ela entra nele pelo acesso remoto;
- o que precisa: PC com Windows **ligado no roteador por cabo de rede**, um Echo na mesma rede de casa, o app da Alexa e um celular. Sem cabo, veja a fase 2: há outro caminho;
- o que vai acontecer: diagnóstico → escolher o caminho → Windows → BIOS → testes em casa → Alexa → acesso remoto → teste de fora pelo 4G. Leva cerca de uma hora, com dois ou três reinícios;
- **a conversa no celular:** na BIOS, o PC fica sem Windows e esta conversa para. Por isso, nessa hora a pessoa abre uma conversa com o Claude no celular. Você prepara um texto para ela colar lá, com o modelo da placa e o que mudar. Lá, ela manda fotos da tela da BIOS e é guiada;
- que dá para parar e continuar depois: é só chamar `/ligar-pc-pela-alexa` de novo.

## Fase 1. Diagnóstico
Rode `scripts/diagnostico.ps1` com `powershell -NoProfile -ExecutionPolicy Bypass -File "<caminho completo>"`. Ele só lê e não precisa de administrador. Mostre um resumo curto:
- placa-mãe, BIOS e processador (decidem os nomes da BIOS);
- a placa de rede com cabo, o **MAC** dela e o **broadcast** da rede (os dois vão no app de teste e na Alexa);
- o que já está certo e o que falta ajustar (seção "O que ajustar" do script);
- o acesso remoto que já existe.

Pergunte o que o script não vê, uma coisa por vez:
- qual Echo ela tem e em que Wi‑Fi ele está (o jeito de conferir está em `guias/alexa.md`). Tem que ser a rede principal de casa, não a de visitantes;
- se o celular é Android ou iPhone;
- se costuma faltar luz (torna obrigatório o teste depois de tirar da tomada);
- como ela entra no PC hoje de longe, se entra: app instalado ou só aberto quando precisa;
- se ela sabe o PIN ou a senha do Windows (vai precisar digitar pelo acesso remoto; quem entra com rosto ou digital às vezes não sabe).

Grave tudo no `progresso.md`.

## Fase 2. Escolher o caminho
Leia `guias/caminhos.md`. Explique as opções em 2 a 3 linhas cada, com prós e contras para o caso dela, e recomende uma. Com cabo e Echo, o padrão é a **skill da Alexa com o Echo**. Sem cabo, ou num PC em que o Wake-on-LAN não funcione, a reserva é a **tomada inteligente**. Espere a escolha. As fases 3 a 6 abaixo são as do caminho do Echo. No caminho da tomada, siga o "Roteiro da tomada" de `guias/caminhos.md` no lugar delas e depois volte para as fases 7 e 8.

## Fase 3. Windows
Leia `guias/windows.md`. A pessoa marca as opções da placa de rede no Gerenciador de Dispositivos (você descreve os cliques) e desliga a inicialização rápida pelo comando do guia. Rode o diagnóstico de novo e mostre que ficou certo antes de seguir.

## Fase 4. BIOS, com a conversa no celular
Leia `guias/bios.md` e `modelos/roteiro-celular.md`.
1. Monte o **roteiro do celular** a partir do modelo: os nomes prováveis das opções para a marca da placa dela, o valor de cada uma, e o texto para colar na conversa do celular. Se você tiver como publicar uma página (um Artifact), publique o roteiro e passe o link para ela abrir no celular. Se não tiver, mostre o texto e peça que ela o mande para o próprio celular (WhatsApp, e-mail ou nota).
2. Confirme que ela abriu o roteiro no celular **antes** de reiniciar, e grave o `progresso.md`.
3. Rode o comando que reinicia direto na BIOS (está no guia), depois do "sim" dela.
4. Quando o Windows voltar, ela diz o que encontrou e o que mudou. Anote no `progresso.md`. Muita BIOS usa nomes diferentes dos do guia: o que valeu nesta placa entra no progresso.

## Fase 5. Testes em casa
Leia `guias/testes.md`. Ajude a escolher e configurar um app de Wake-on-LAN atual no celular, com o **broadcast** (não o IP do PC). Depois, os testes, um de cada vez:
1. a partir da **suspensão**;
2. a partir do **desligado**;
3. **depois de tirar da tomada** por 30 segundos (simula a falta de luz; obrigatório se falta luz na casa dela).

Se algum falhar, pare e siga o diagnóstico do guia. Não passe para a Alexa com teste falhando: a Alexa só manda o mesmo pacote, e se o PC não liga com o app, também não vai ligar com ela.

## Fase 6. Alexa
Leia `guias/alexa.md`. Ajude a escolher a skill (confira na loja da Alexa do país dela se ainda está disponível e grátis), cadastrar o PC, **conferir que o MAC principal é o da placa com cabo** e vincular a conta. Teste em casa pelo app da Alexa, com o PC desligado.

## Fase 7. Acesso remoto
Leia `guias/acesso-remoto.md`. Confira se o app de acesso remoto dela roda **antes do login** e tem a **senha de acesso sem ninguém na frente**. Se ela não tiver um, ajude a escolher.

## Fase 8. Teste de fora e fechamento
1. PC desligado pelo Iniciar → Desligar, **Wi‑Fi do celular desligado** (só 4G): app da Alexa → o PC → Ligar. Esperar cerca de 1 minuto e entrar pelo acesso remoto. Deve aparecer a tela de login do Windows.
2. Se passou, mostre o uso do dia a dia em 3 linhas: ligar pela Alexa, esperar 1 minuto, entrar pelo acesso remoto. Mais três avisos curtos:
   - se o PC acordou da suspensão e ninguém conectou, o Windows volta a dormir em uns 2 minutos: é só tocar em Ligar de novo;
   - se um dia parar de ligar (depois de atualização grande do Windows, por exemplo), rodar o diagnóstico antes de tudo;
   - o que fazer se trocar de roteador, de placa de rede ou de Echo (ver `guias/alexa.md`).
3. Marque o `progresso.md` como concluído, com o que valeu no hardware dela.

## Regras
- Nunca mude BIOS, roteador ou conta da pessoa por ela, nem aprove janela de administrador por ela.
- Nunca peça senha, código de verificação ou login. Login na Amazon, na skill e no acesso remoto é com ela.
- Instalar app ou programa só depois de explicar o que é e de ela dizer "sim".
- Não prometa que vai funcionar antes dos testes: placa de rede, BIOS e roteador variam.
- O MAC e o IP dela ficam no `progresso.md` e no roteiro. Não ponha esses dados em lugar público.
