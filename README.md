# Ligar o PC pela Alexa

Uma skill gratuita para o Claude Code que te guia, passo a passo, a deixar o seu PC com Windows pronto para **ligar pelo app da Alexa, de qualquer lugar**, e entrar nele de longe pelo AnyDesk (ou outro acesso remoto).

Quem manda o sinal que liga o PC é o seu próprio Echo, de dentro de casa. Não precisa abrir porta no roteador nem deixar outro aparelho ligado.

Ela não é um tutorial fixo: confere o seu hardware, adapta os nomes da BIOS à sua placa-mãe, explica cada escolha e testa cada passo com você. O roteiro saiu de uma configuração real, feita do zero até funcionar pelo 4G, com as armadilhas que apareceram no caminho.

## O que você precisa
- PC com Windows **ligado no roteador por cabo de rede**. Sem cabo, a skill te mostra outro caminho, com tomada inteligente.
- Um Echo (Echo, Echo Dot, Echo Show, Echo Pop…) na mesma rede de casa.
- O app da Alexa e um celular.
- [Claude Code](https://claude.com/claude-code) no PC, e o app do Claude no celular para a parte da BIOS.

## Como instalar
Abra o Claude Code e cole:

```
Instala esta skill para mim: https://github.com/kaiosmacedo/ligar-pc-pela-alexa
```

Ou, no PowerShell:

```powershell
git clone https://github.com/kaiosmacedo/ligar-pc-pela-alexa "$HOME\.claude\skills\ligar-pc-pela-alexa"
```

## Como usar
No Claude Code, digite:

```
/ligar-pc-pela-alexa
```

Ela te guia por estas etapas:

1. **Diagnóstico:** lê a placa de rede, a placa-mãe e o acesso remoto, sem mudar nada.
2. **Caminho:** skill da Alexa com o Echo (o padrão) ou tomada inteligente, com os prós e contras para o seu caso.
3. **Windows:** as opções de energia da placa de rede e a inicialização rápida.
4. **BIOS:** prepara um roteiro e um texto para você levar numa conversa com o Claude no celular. Durante a BIOS, o PC fica sem Windows, e é lá que você manda fotos da tela e é guiado.
5. **Testes em casa:** com um app no celular, a partir da suspensão, do desligado e depois de uma falta de luz.
6. **Alexa:** a skill que cadastra o PC, conferindo o endereço certo da placa.
7. **Acesso remoto:** confere se ele já funciona na tela de login.
8. **Teste de fora:** pelo 4G, ligar pela Alexa e entrar.

O PC reinicia algumas vezes no caminho. A skill anota onde parou em `~/ligar-pc-pela-alexa/progresso.md`, e é só chamar `/ligar-pc-pela-alexa` de novo para continuar.

## O que tem aqui
| Pasta | O que tem |
|---|---|
| `SKILL.md` | O roteiro da conversa |
| `guias/` | O conhecimento de cada etapa: caminhos, Windows, BIOS por marca, testes, Alexa e acesso remoto |
| `modelos/` | O caderno de progresso e o roteiro do celular |
| `scripts/` | `diagnostico.ps1` (só lê) e `escutar-wol.ps1` (mostra se o sinal do celular chega ao PC) |

Tudo em texto. Leia, mude, adapte.

## Licença
MIT. Use, mude e compartilhe à vontade.

Feito por Kaio Macedo.
