---
name: criar-post
description: Cria post completo de redes sociais (copy + design no Canva) usando o design system e a voz da marca. Lê contexto/VOZ.md e contexto/DESIGN.md, gera copy seguindo a voz, brief de design textual, e cria o design no Canva via MCP aplicando o Brand Kit cadastrado. Use sempre que o usuário pedir "criar post", "fazer carrossel", "post para Instagram", "design para LinkedIn", "arte pra rede social", "fazer um carrossel" ou similar.
allowed-tools: Read, Write, Bash(mkdir -p *), Bash(date:*)
---

# Skill: Criar Post

Cria post (copy + design) para redes sociais com Brand Kit do Canva aplicado.

## Pré-requisitos

- MCP Canva conectado (rode `/mcp` 1x para autenticar)
- Brand Kit cadastrado em https://canva.com/brand (cores, fontes, logo)
- `contexto/DESIGN.md` descreve o Brand Kit em texto, com os mesmos nomes que estão no Canva

## Workflow

### Passo 1 — Campanha + contexto

Identifique a **campanha** (`operacao/<slug>/`): se nova, crie + `BRIEFING.md`; se existe, leia o `BRIEFING.md` dela. Carregue o brand:
- `contexto/VOZ.md`
- `contexto/DESIGN.md`
- `contexto/EMPRESA.md` (se faltar contexto sobre produto/oferta)

### Passo 2 — Entrevista

Faça UMA por vez:

1. **Plataforma**: Instagram, LinkedIn, X (Twitter), TikTok?
2. **Formato**: post único (1080×1080 ou 1080×1350), carrossel (quantos slides?), story (1080×1920), capa de Reels (1080×1920)?
3. **Objetivo**: consciência, engajamento, lead, venda?
4. **Tema central** em 1 frase
5. **CTA**: o que você quer que a pessoa faça depois? (clicar no link da bio, comentar, salvar, mandar DM, etc)

### Passo 3 — Copy

Gere o copy seguindo estritamente `contexto/VOZ.md`. Estrutura geral:

- **Hook** (primeira linha): impactante, controverso ou curioso
- **Corpo**: blocos curtos, frases curtas, exemplos concretos
- **CTA**: direto, sem rodeio
- **Hashtags**: 5–10 (LinkedIn: 3–5)

Para **carrossel**: copy slide a slide, com hierarquia clara. Cada slide tem:
- Headline grande (max 8 palavras)
- Subhead (opcional, max 15 palavras)
- Slide final = CTA forte

Apresente o copy. Espere ajustes ou aprovação.

### Passo 4 — Brief de design

Gere um design brief textual:

```
## Design Brief

**Dimensões**: <ex: 1080×1080>
**Plataforma**: <ex: Instagram feed>

**Brand Kit a usar (nomes de contexto/DESIGN.md)**:
- Cor de fundo: <referência do Brand Kit, ex: "Azul Marca">
- Cor de texto principal: <referência>
- Cor de destaque: <referência>
- Fonte do headline: <referência>
- Fonte do body: <referência>

**Layout (hierarquia)**:
1. <ex: "Logo da marca em branco no canto superior esquerdo, escala pequena">
2. <ex: "Headline ocupa 50% da altura, centro vertical, texto em branco">
3. <ex: "Subhead abaixo, 1/4 do tamanho do headline">
4. <ex: "CTA em barra inferior com cor de destaque">

**Mood**: <descrição visual: minimalista? denso? formal? despojado?>

**Assets adicionais**: <ícones, ilustrações, fotos extras se houver>
```

### Passo 5 — Canva via MCP

Use o MCP do Canva (`mcp__canva__*`) para criar o design. Prompt para o MCP, usando o brief gerado:

```
Crie um design <formato> de <dimensões> para <plataforma>, aplicando meu Brand Kit "<nome do Brand Kit>":

- Headline: "<texto>"
- Subhead: "<texto>"
- CTA: "<texto>"
- Cor de fundo: <referência do Brand Kit>
- Fonte do título: <referência do Brand Kit>
- Estilo geral: <mood>
- Logo: <posição>

<Para carrossel, repita os campos por slide.>
```

### Passo 6 — Salvar artefatos

```bash
DATA=$(date +%F)
CAMPANHA="<slug-da-campanha>"
SLUG="<slug-do-post>"  # ex: anuncio-sucessao-li
DIR="operacao/${CAMPANHA}/posts/${DATA}-${SLUG}"
mkdir -p "$DIR"
```

Salve:
- `${DIR}/copy.md` — copy final
- `${DIR}/design-brief.md` — brief usado
- `${DIR}/canva-link.txt` — URL/ID do design no Canva
- `${DIR}/README.md` — meta (data, plataforma, objetivo, status)

### Passo 7 — Mostrar e iterar

Mostre a URL do design ao usuário. Pergunte: "Aprovado, ajustar ou refazer?"

Se ajustar ("mude para verde", "aumente headline", "use o logo positivo"), envie comando follow-up ao MCP Canva referenciando o mesmo design ID — o MCP suporta iteração.

## Troca de ferramenta de design

Se o usuário usa Figma em vez de Canva:
1. Troque a entrada `canva` no `.mcp.json` por `figma`
2. Substitua `mcp__canva__*` por `mcp__figma__*` neste skill
3. Ajuste o Passo 5 (Figma usa "Frames" e tem flow ligeiramente diferente)

## Limitações conhecidas do Canva MCP

- **Brand Kit avançado** (autofill de templates) requer Canva Pro+
- **Brand Templates** com autofill total requerem Canva Enterprise
- **Free tier**: Brand Kit limitado basicamente a cores
- Elementos gráficos complexos (logos posicionados, assets específicos) podem precisar ajuste manual no Canva após geração — não prometa "zero ajuste"
