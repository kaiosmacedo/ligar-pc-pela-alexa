# Modelo: progresso.md

O caderno da configuração. Fica em `~/ligar-pc-pela-alexa/progresso.md` e é atualizado ao fim de cada fase. É por ele que a skill retoma de onde parou depois de um reinício.

---

```markdown
# Ligar o PC pela Alexa

Fase atual: <0–8> · Atualizado em <data>

## Hardware
- PC: <desktop | notebook> · Windows <edição e build>
- Placa-mãe: <marca e modelo> · BIOS <fabricante e versão> · Processador: <…>
- Placa de rede com cabo: <modelo> · MAC <…> · driver <…>
- Rede: IP <…> · broadcast <…> · roteador <…>
- Echo: <modelo>, no Wi‑Fi <principal | outro>
- Celular: <Android | iPhone>
- Falta luz com frequência: <sim | não>

## Caminho escolhido
<skill da Alexa com o Echo | tomada inteligente | …>, porque <…>

## Windows
- Gerenciamento de Energia da placa: <ok | falta>
- Aba Avançado: <o que estava e o que mudou>
- Inicialização rápida: <desligada | ligada>

## BIOS (nomes reais desta placa)
- ErP: "<nome>" em <menu> · estava <…> · ficou <…>
- Wake on LAN: "<nome>" em <menu> · estava <…> · ficou <…>
- Energia volta: "<nome>" · <valor>

## Testes em casa (app <nome>, broadcast <…>)
- Suspensão: <passou | falhou: o quê>
- Desligado: <…>
- Depois de tirar da tomada: <…>

## Alexa
- Skill: <nome> · MAC principal <…> · vinculada <sim | não>
- Teste em casa pelo app da Alexa: <…>

## Acesso remoto
- App: <…> · serviço antes do login <sim | não> · senha sem ninguém <sim | não>

## Teste de fora (4G)
- <data>: <ligou | não ligou> · acesso remoto <entrou | não>

## Próximo passo
<…>
```
