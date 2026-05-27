---
name: criar-criativo
description: Cria criativos visuais (1:1 e 9:16) para campanhas e posts usando Gemini 2.5 Flash Image. Lê contexto da empresa, faz entrevista estruturada (objetivo, big idea, formato), gera 3 conceitos para aprovação humana, e renderiza imagens nos dois formatos. Salva em operacao/<iniciativa>/criativos/<data>/. Use sempre que o usuário pedir "criar criativo", "gerar arte", "imagem para anúncio", "post visual", "criativo de tráfego", "arte pra campanha", "imagem pra rede social" ou similar.
allowed-tools: Bash(./.claude/skills/criar-criativo/scripts/gen_image.sh:*), Bash(./.claude/skills/criar-criativo/scripts/render_html.sh:*), Bash(mkdir -p *), Bash(date:*), Read, Write, Glob
---

# Skill: Criar Criativo

Gera criativos visuais nos formatos 1:1 (feed) e 9:16 (story/reels) a partir do contexto da empresa, via Gemini 2.5 Flash Image.

## Pré-requisitos

- `GEMINI_API_KEY` definido em `.env` (raiz do projeto)
- Arquivos `contexto/EMPRESA.md`, `contexto/VOZ.md`, `contexto/DESIGN.md` preenchidos
- (Recomendado) logo da marca em `contexto/ativos/` — usado como referência de fidelidade
- `jq` e `base64` disponíveis no shell (já vêm no macOS/Linux)
- Para o **Caminho B (HTML, pixel-perfect)**: Google Chrome instalado (o render usa Chrome headless)

## Workflow

### Passo 1 — Carregar contexto

Leia, nesta ordem:

1. `contexto/EMPRESA.md`
2. `contexto/VOZ.md`
3. `contexto/DESIGN.md`

### Passo 2 — Identificar a iniciativa

Pergunte: "Em qual iniciativa vamos trabalhar? (ex: `low-ticket-ebook`, `lancamento-q3` — kebab-case)"

Se for nova, crie `operacao/<slug>/` e um `BRIEFING.md` mínimo dentro com oferta, avatar, awareness e ângulo.

Se já existe, leia `operacao/<slug>/BRIEFING.md` para herdar o contexto da iniciativa (oferta, avatar, ângulo) antes de continuar.

### Passo 3 — Entrevista estruturada

Faça as perguntas UMA POR VEZ. Espere a resposta antes da próxima. Não pule perguntas.

1. **Objetivo**: Consciência (alcance, lembrança), Conversão (clique, lead, venda) ou Retenção (re-engajamento)?
2. **Etapa do funil**: topo, meio ou fundo?
3. **Big idea central** em 1 frase. Se o usuário não tiver, sugira 3 baseadas em `contexto/EMPRESA.md` (ofertas + ICP) e `contexto/VOZ.md`.
4. **Formato**: 1:1 (feed), 9:16 (story/reels), ou ambos?
5. **Restrições**: cores específicas, palavras a evitar, referências visuais, elementos obrigatórios? Logo aparece?

### Passo 4 — Gerar 3 conceitos

Crie 3 conceitos visualmente diferenciados. Para cada um, apresente:

```
## Conceito N: <nome curto>

**Big idea**: <1 frase>

**Direção visual**: <cena, mood, paleta, estilo>

**Prompt Gemini**:
<prompt detalhado: cena, estilo fotográfico ou ilustrativo, paleta exata do DESIGN.md, mood, luz, elementos sobrepostos se houver, instruções de texto se houver. Use inglês ou português conforme funcionar melhor. Inclua restrições do DESIGN.md (ex: "no people with text on shirts", "respect brand color #1A2E4A as primary background").>
```

Apresente os 3 lado a lado. Pergunte: "Qual conceito aprovado? Ajustar antes de gerar?"

### Passo 5 — Renderizar (dois caminhos)

Prepare a pasta de saída:

```bash
DATA=$(date +%F)
SLUG="<slug-da-iniciativa>"
OUT_DIR="operacao/${SLUG}/criativos/${DATA}"
mkdir -p "${OUT_DIR}"
```

Escolha o caminho conforme a peça:

#### Caminho A — Gemini (`gen_image.sh`): conceito ilustrativo / fotográfico
Melhor pra cena, mood, fundo, ilustração. **Passe o logo (de `contexto/ativos/`) como 4º argumento** pra fidelidade do símbolo:

```bash
LOGO="contexto/ativos/<logo-da-marca>.png"   # recomendado
./.claude/skills/criar-criativo/scripts/gen_image.sh "<prompt>" "1:1"  "${OUT_DIR}/conceito-N_1x1.png"  "$LOGO"
./.claude/skills/criar-criativo/scripts/gen_image.sh "<prompt>" "9:16" "${OUT_DIR}/conceito-N_9x16.png" "$LOGO"
```

> O Gemini APROXIMA cor/fonte/logo. Use os HEX exatos no prompt e descreva o símbolo REAL — nunca genérico.

#### Caminho B — HTML render (`render_html.sh`): peça tipográfica / institucional **pixel-perfect** — RECOMENDADO quando há `DESIGN.md` com tokens + logo
A arte é construída em HTML/CSS com os **tokens exatos** da marca (HEX + fontes via Google Fonts) e o **logo oficial** embarcado — render fiel, zero aproximação. Se tiver o `/ui-ux-pro-max` (gstack), use-o pra decisões de layout/tipografia/hierarquia.

1. Leia os tokens de `contexto/DESIGN.md` (HEX, famílias de fonte) e localize o logo em `contexto/ativos/`.
2. Copie `.claude/skills/criar-criativo/assets/creative.template.html` pro `${OUT_DIR}` (um arquivo por formato) e preencha os placeholders: cores (`--bg/--primary/--accent/--muted`), fontes (nomes do Google Fonts no `@import` e nas regras), `LOGO_PATH` (caminho ABSOLUTO do logo), `HEADLINE` + `KEYWORD` (palavra em itálico de acento), `EYEBROW`, `TAGLINE`. No 9:16, troque `height` pra `1920px`.
3. Renderize cada formato:

```bash
./.claude/skills/criar-criativo/scripts/render_html.sh "${OUT_DIR}/conceito-N_1x1.html"  "${OUT_DIR}/conceito-N_1x1.png"  1080 1080
./.claude/skills/criar-criativo/scripts/render_html.sh "${OUT_DIR}/conceito-N_9x16.html" "${OUT_DIR}/conceito-N_9x16.png" 1080 1920
```

> Regra: fundo claro deixa o logo colorido aparecer sem recolorir; pra fundo escuro, prepare uma versão clara do logo. Respeite a proporção cromática do `DESIGN.md`.

### Passo 6 — Mostrar

Para cada arquivo gerado, use `Read <caminho>` para exibir inline no chat. Claude Code é multimodal e renderiza PNG.

### Passo 7 — Iteração

Pergunte: "Aprovado, ajustar ou refazer?"

- **Ajustar**: refine o prompt e regere apenas o formato pedido.
- **Refazer**: volte ao Passo 4 com conceitos novos.
- **Aprovado**: salve em `${OUT_DIR}/PROMPT.md`:
  ```markdown
  # Prompt final
  
  **Conceito**: <nome>
  **Big idea**: <frase>
  
  ## Prompt usado
  <prompt completo>
  
  ## Arquivos
  - conceito-N_1x1.png
  - conceito-N_9x16.png
  ```

## Notas operacionais

- **Fidelidade de marca**: o Gemini APROXIMA cor, fonte e símbolo. Para **pixel-perfect** (HEX, fonte e logo exatos), use o **Caminho B (HTML render)** — é o que garante a marca. Alternativa: finalizar no Canva (skill `criar-post`). No Gemini, passar o logo como 4º arg aproxima o símbolo e evita genérico.
- Cada imagem custa ~US$0,039 (Gemini 2.5 Flash Image, 1024×1024 padrão). 3 conceitos × 2 ratios = 6 imagens = US$0,234 por execução completa.
- Watermark SynthID invisível é embedded automaticamente — não tente removê-lo.
- Para mudar para Gemini 3.x (preview, melhor texto): edite `scripts/gen_image.sh` trocando o model ID.
- Se receber erro 429, espere 60s e tente novamente (rate limit).
- Free tier do Google AI Studio: 1.500 requests/dia em Flash. Acima disso, ativar billing.
