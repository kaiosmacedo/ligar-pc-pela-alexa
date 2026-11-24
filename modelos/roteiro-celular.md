# Modelo: roteiro do celular

O que a pessoa leva no celular para a BIOS. Tem duas partes: a lista para ela marcar e o texto para colar numa conversa nova com o Claude no celular. Preencha tudo o que está entre `< >` antes de entregar. Se puder publicar uma página (Artifact), publique as duas partes numa página só, com caixas de marcar e um botão de copiar o texto; senão, entregue em texto.

Confirme que ela abriu no celular **antes** de dar o comando de reiniciar.

---

## Parte 1: a lista

```markdown
# BIOS do <apelido do PC>

Placa-mãe <modelo> · BIOS <fabricante versão>. <Se houver: "Aperte <tecla> para o modo avançado.">
Os nomes podem variar: procure em Advanced, Power, APM ou ACPI.

- [ ] ErP (<nomes prováveis>) = Disabled
- [ ] Wake on LAN (<nomes prováveis>) = Enabled
- [ ] <Restore on AC Power Loss / nome provável> = <Power Off (caminho do Echo) | Power On (caminho da tomada)>
- [ ] <F10 | botão de salvar da tela>, salvar e sair

Se travar: Esc → sair sem salvar. Nada muda.
Depois: volte para a conversa do PC e conte o que achou em cada item.
```

## Parte 2: o texto para colar no Claude do celular

```text
Estou na BIOS do meu PC e preciso de ajuda para achar algumas opções. Placa-mãe <marca e modelo>, BIOS <fabricante> versão <versão>, processador <modelo>. <Se houver: "Ela abre num modo fácil; o avançado é na tecla <tecla>.">
Quero mudar e salvar:
1) <ErP / nomes prováveis> = Disabled
2) <Wake on LAN / nomes prováveis> = Enabled
3) <Restore on AC Power Loss / nome provável> = <valor> (só conferir)
4) Salvar e sair (<F10 | botão da tela>).
Vou mandar fotos da tela. Me guie um passo por vez e me diga em qual menu entrar. Não quero mudar mais nada além disso.
```
