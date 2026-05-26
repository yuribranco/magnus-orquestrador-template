---
name: checar-marca
description: Garante fidelidade total à identidade da empresa em qualquer peça visual ou textual. Carrega contexto/DESIGN.md, contexto/VOZ.md e contexto/ativos/ ANTES de produzir (injeta tokens exatos — HEX, tipografia, logo, proporção, voz) e revisa DEPOIS contra um checklist de marca, sinalizando desvios. Use sempre que for criar ou revisar criativo, post, slide, página, anúncio, e-mail ou qualquer asset de marca — e sempre antes de aprovar um output visual como "pronto".
allowed-tools: Read, Glob, Grep, Bash(file:*)
---

# Skill: Checar Marca (garantia de fidelidade)

Esta skill é o guardião da identidade. Roda em dois momentos:

1. **Antes de produzir** (pré-flight) — monta o "Bloco de Marca" com os tokens exatos pra injetar no prompt/brief de quem vai gerar (`criar-criativo`, `criar-post`, página, slide…).
2. **Depois de produzir** (QC) — confere a peça contra o checklist e exige correção dos desvios antes de aprovar como "pronto".

## Princípio

O Claude (e o Gemini) **aproximam** a marca quando recebem descrição vaga — inventam um símbolo genérico, chutam a cor, trocam a fonte. Fidelidade vem de três coisas, e esta skill força as três:

1. **Tokens exatos** no prompt/brief (HEX com nome, trio tipográfico, proporção).
2. **Assets reais como referência** (passar o logo de `contexto/ativos/` como imagem de referência).
3. **Acabamento de logo/fonte/cor no Canva** quando o pixel-perfect importa (o Gemini nunca reproduz exato).

## Pré-flight — antes de gerar qualquer peça

1. Leia `contexto/DESIGN.md` e `contexto/VOZ.md`. Liste `contexto/ativos/` (logos, fontes).
2. Monte o **Bloco de Marca** e cole no prompt/brief da skill de produção:

```
PALETA (use EXATAMENTE estes HEX e nomes): <nome=#hex + uso, do DESIGN.md>
PROPORÇÃO / HIERARQUIA de cor: <ex: 70/25/5; cor primária dominante; acento restrito>
TIPOGRAFIA (só estas famílias): <heading / subheading / body + pesos>
LOGO: <arquivo em contexto/ativos/ — passar como referência (4º arg do gen_image.sh)>
SÍMBOLO REAL: <descreva o símbolo da marca em detalhe — NUNCA um genérico/placeholder>
VOZ: <tom + 3 palavras que USAMOS + 3 que EVITAMOS, do VOZ.md>
PROIBIDO: <do DESIGN.md — ex: gradiente, emoji, fonte fora do trio, +1 acento por peça>
```

3. **Criativo (Gemini / `criar-criativo`)**: passe o logo de `contexto/ativos/` como 4º argumento do `gen_image.sh` e use os HEX exatos no texto. Lembre: o Gemini APROXIMA — pra logo/fonte/cor exatos, finalize no Canva.
4. **Post (Canva / `criar-post`)**: confirme que os nomes de cor/fonte do brief batem com o Brand Kit cadastrado (mesmos nomes do DESIGN.md).

## QC — depois de gerar (checklist, antes de aprovar)

Marque cada item. Qualquer ❌ = ajustar/refazer antes de chamar de "pronto":

- [ ] **Cores** — só as do DESIGN.md? Proporção/hierarquia respeitada?
- [ ] **Tipografia** — só o trio da marca?
- [ ] **Logo/símbolo** — é o REAL da marca (não genérico)? Versão e cor corretas pro fundo?
- [ ] **Voz** (se há texto) — bate com VOZ.md? Sem palavra da lista de "evitar"?
- [ ] **Proibições** — nenhuma violada (gradiente, emoji, fonte fora do trio…)?
- [ ] **Teste de 1 segundo** — dá pra reconhecer a marca sem precisar explicar?

Se algum item falhar por limite do Gemini (símbolo/fonte aproximados), recomende o acabamento no Canva (skill `criar-post`) com os assets exatos — não aprove uma aproximação como peça final.

## Quando NÃO bloquear

Rascunho interno / exploração de conceito não precisa passar no QC. O gate é **antes de entregar ou publicar**.

## Para trabalho de web / UI (opcional)

Se a peça for uma **landing page, dashboard ou interface** (não criativo de social), e você tiver o `/ui-ux-pro-max` do gstack instalado, use-o para decisões de layout, componentes e font pairing — ele complementa este checklist no domínio de UI/web. Sem ele, este Bloco de Marca + o DESIGN.md já são suficientes.
