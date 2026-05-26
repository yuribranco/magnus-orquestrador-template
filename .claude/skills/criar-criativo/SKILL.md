---
name: criar-criativo
description: Cria criativos visuais (1:1 e 9:16) para campanhas e posts usando Gemini 2.5 Flash Image. Lê contexto da empresa, faz entrevista estruturada (objetivo, big idea, formato), gera 3 conceitos para aprovação humana, e renderiza imagens nos dois formatos. Salva em operacao/projetos/<slug>/criativos/<data>/. Use sempre que o usuário pedir "criar criativo", "gerar arte", "imagem para anúncio", "post visual", "criativo de tráfego", "arte pra campanha", "imagem pra rede social" ou similar.
allowed-tools: Bash(./.claude/skills/criar-criativo/scripts/gen_image.sh:*), Bash(mkdir -p *), Bash(date:*), Read, Write, Glob
---

# Skill: Criar Criativo

Gera criativos visuais nos formatos 1:1 (feed) e 9:16 (story/reels) a partir do contexto da empresa, via Gemini 2.5 Flash Image.

## Pré-requisitos

- `GEMINI_API_KEY` definido em `.env` (raiz do projeto)
- Arquivos `contexto/EMPRESA.md`, `contexto/VOZ.md`, `contexto/DESIGN.md` preenchidos
- (Recomendado) logo da marca em `contexto/ativos/` — usado como referência de fidelidade
- `jq` e `base64` disponíveis no shell (já vêm no macOS/Linux)

## Workflow

### Passo 1 — Carregar contexto

Leia, nesta ordem:

1. `contexto/EMPRESA.md`
2. `contexto/VOZ.md`
3. `contexto/DESIGN.md`

### Passo 2 — Identificar projeto

Pergunte: "Em qual projeto vamos trabalhar? (Se for novo, me dá o nome em kebab-case, ex: `aquecimento-q3-sucessao`)"

Se for novo, crie `operacao/projetos/<slug>/` e um `BRIEF.md` mínimo dentro com objetivo + público.

Se já existe, leia `operacao/projetos/<slug>/BRIEF.md` para entender o histórico antes de continuar.

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

### Passo 5 — Renderizar

Após aprovação, prepare:

```bash
DATA=$(date +%F)
SLUG="<slug-do-projeto>"
OUT_DIR="operacao/projetos/${SLUG}/criativos/${DATA}"
mkdir -p "${OUT_DIR}"
```

Depois rode o script duas vezes (1:1 + 9:16). **Para fidelidade de marca, passe o logo da empresa (de `contexto/ativos/`) como 4º argumento** — o Gemini usa como referência visual em vez de inventar um símbolo genérico:

```bash
LOGO="contexto/ativos/<logo-da-marca>.png"   # opcional, mas recomendado

./.claude/skills/criar-criativo/scripts/gen_image.sh \
  "<prompt aprovado>" "1:1" "${OUT_DIR}/conceito-N_1x1.png" "$LOGO"

./.claude/skills/criar-criativo/scripts/gen_image.sh \
  "<prompt aprovado>" "9:16" "${OUT_DIR}/conceito-N_9x16.png" "$LOGO"
```

> Sem o 4º argumento, o script funciona igual (só texto). Sempre use os HEX exatos do `contexto/DESIGN.md` no prompt e descreva o símbolo REAL da marca — nunca um placeholder genérico.

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

- **Fidelidade de marca**: o Gemini APROXIMA cor, fonte e símbolo — não reproduz pixel-perfect. Para logo, tipografia e cor exatos, gere a ARTE/fundo aqui e finalize a peça no Canva (skill `criar-post`, com Brand Kit aplicado). Passar o logo da marca como referência (4º arg do script) aproxima muito o símbolo real e evita "placeholder genérico".
- Cada imagem custa ~US$0,039 (Gemini 2.5 Flash Image, 1024×1024 padrão). 3 conceitos × 2 ratios = 6 imagens = US$0,234 por execução completa.
- Watermark SynthID invisível é embedded automaticamente — não tente removê-lo.
- Para mudar para Gemini 3.x (preview, melhor texto): edite `scripts/gen_image.sh` trocando o model ID.
- Se receber erro 429, espere 60s e tente novamente (rate limit).
- Free tier do Google AI Studio: 1.500 requests/dia em Flash. Acima disso, ativar billing.
