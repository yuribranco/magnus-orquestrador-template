---
name: lancar-campanha
description: Planeja lançamento completo aplicando framework Eugene Schwartz (awareness stages, sophistication stages, mecanismo único, oferta) e cria todas as tarefas no Notion via MCP. Faz entrevista estruturada de 10 perguntas, gera BRIEF.md, CRONOGRAMA.md e TAREFAS.md, e popula uma database de tarefas no Notion. Use sempre que o usuário pedir "lançar campanha", "planejar lançamento", "estruturar campanha", "fazer um lançamento", "estratégia Schwartz", "campanha de aquisição" ou similar.
allowed-tools: Read, Write, Bash(mkdir -p *), Bash(date:*)
---

# Skill: Lançar Campanha

Estrutura um lançamento completo aplicando Eugene Schwartz e materializa em Notion.

## Pré-requisitos

- MCP Notion conectado (rode `/mcp` 1x)
- Workspace Notion com pelo menos uma página parent disponível
- Familiaridade básica com awareness/sophistication stages (carregue `references/schwartz-framework.md` se precisar)

## Referências do skill

Carregue conforme necessário:

- `references/schwartz-framework.md` — detalhamento dos stages
- `references/notion-schema.md` — schema da database
- `assets/BRIEF.template.md` — template do brief
- `assets/CRONOGRAMA.template.md` — template do cronograma
- `assets/TAREFAS.template.md` — template da lista de tarefas

## Workflow

### Passo 1 — Setup

Pergunte:

1. **Slug** da campanha em kebab-case (ex: `lancamento-q3-2026`)
2. **Data de abertura** de carrinho ou launch principal (YYYY-MM-DD)
3. **Data de fechamento** (YYYY-MM-DD)

Crie `operacao/<slug>/`.

### Passo 2 — Entrevista Schwartz

Faça as 10 perguntas EM ORDEM, UMA POR VEZ. Sem follow-up até receber resposta. Se a resposta for vaga, pergunte detalhes UMA vez antes de seguir.

1. **PRODUTO**: O que está sendo vendido? (1 frase)
2. **PROMESSA PRINCIPAL**: Qual o resultado que o cliente compra? Use os eixos LHPSO (Largest, Highest probability, Permanence, Speed, Otherness) como guia — pergunte qual eixo é o principal.
3. **AVATAR PRIMÁRIO**:
   - Quem é? (idade, profissão, momento de vida)
   - Em qual **stage of awareness** está? (Unaware, Problem Aware, Solution Aware, Product Aware, Most Aware) — se não souber, mostre as opções de `references/schwartz-framework.md` e ajude a decidir.
4. **MERCADO**:
   - Em qual **stage of sophistication** o mercado está? (1 a 5) — idem, ajude se necessário.
   - 3 concorrentes diretos (nomes)
5. **MECANISMO ÚNICO**: Por que SUA solução funciona quando outras não? (sistema, método, ingrediente, processo)
6. **BIG IDEA**: A ideia provocativa em 1 frase. Se não souber, sugira 3 baseadas no avatar + mecanismo.
7. **OFERTA**: preço, bônus (lista), garantia, escassez (vagas, datas, preço sobe)
8. **INVESTIMENTO**: orçamento em mídia paga + canais orgânicos planejados
9. **DATAS-CHAVE** (além das do Passo 1): início de aquecimento, fim de aquecimento, pré-lançamento, lives/eventos, fechamento
10. **KPIs**: 3 métricas alvo (ex: 50 vendas, CPA <R$300, taxa de conversão >8%)

### Passo 3 — BRIEF

Use `assets/BRIEF.template.md` como base. Sintetize as 10 respostas em:

- Resumo executivo (3 linhas)
- Avatar + awareness stage
- Mercado + sophistication stage
- Mecanismo único
- Big idea
- Oferta completa
- Hipóteses críticas a testar (gere 3 baseadas nas respostas)
- KPIs

Salve em `operacao/<slug>/BRIEFING.md`. Mostre ao usuário. Espere aprovação.

### Passo 4 — CRONOGRAMA

Use `assets/CRONOGRAMA.template.md`. Calcule datas retroagindo da abertura:

- D-21: Início aquecimento (3+ conteúdos problem-aware)
- D-14: Conteúdo solution-aware (revela mecanismo)
- D-7: Webinar/Live de demonstração de mecanismo
- D-3: Pré-lançamento (sneak peek da oferta)
- D-0: Abertura de carrinho
- D+1: E-mail de prova social
- D+3: E-mail de escassez
- D+5: Fechamento de carrinho
- D+7: Pós-lançamento (depoimentos, próximos passos)

Ajuste conforme a duração que o usuário definiu. Salve em `operacao/<slug>/CRONOGRAMA.md`.

### Passo 5 — TAREFAS

Use `assets/TAREFAS.template.md` como base. Gere 40–80 tarefas distribuídas em categorias:

- **Copy**: e-mails, anúncios, página de vendas, scripts de live/VSL
- **Criativo**: imagens, banners, capas de e-mail, miniaturas
- **Vídeo**: VSL, reels, lives, depoimentos
- **Email**: sequência de aquecimento, abertura, vendas, fechamento
- **Anúncio**: criativos + estruturas de campanha (Meta Ads, Google Ads)
- **Operacional**: setup técnico (página, pixel, automações, integrações, checkout, tracking)

Para cada tarefa:
- **Título** (verbo no infinitivo, ex: "Escrever e-mail de abertura D-0")
- **Dono** (se mencionado, caso contrário deixar em branco)
- **Data sugerida** (calculada do cronograma, format YYYY-MM-DD)
- **Prioridade** (Alta/Média/Baixa)
- **Etapa** (Aquecimento/Pré-lançamento/Abertura/Fechamento/Pós)
- **Tipo** (categoria acima)
- **Descrição curta** (1 linha)

Salve em `operacao/<slug>/TAREFAS.md`. Mostre resumo (contagem por categoria). Espere aprovação.

### Passo 6 — Notion

Pergunte: "Vou criar a database '**Magnus — <slug>**' no Notion e popular <X> tarefas. OK? Em qual página parent você quer? (Posso buscar pra você se me der o nome.)"

Se aprovado:

1. Use `mcp__notion__search` para encontrar a página parent pelo nome.
2. Verifique se já existe database com esse nome lá (idempotência) via `mcp__notion__fetch` ou `mcp__notion__search`.
3. Se não existir, crie via `mcp__notion__create_database` usando o schema de `references/notion-schema.md`.
4. Para cada tarefa de TAREFAS.md, crie via `mcp__notion__create_pages`. **Reporte progresso a cada 10 tarefas** para não bloquear o usuário.
5. Capture a URL final da database.

> Rate limit do Notion MCP: ~180 req/min. Se receber 429, espere e tente novamente.

### Passo 7 — Documentação

Salve `operacao/<slug>/notion-url.txt` com o link da database.

Atualize `operacao/<slug>/BRIEFING.md` no final adicionando seção:

```markdown
## Status

- BRIEF: ✅ criado
- CRONOGRAMA: ✅ criado
- TAREFAS: ✅ criadas (X tarefas)
- Notion: ✅ database criada → <URL>

## Próximos passos sugeridos

1. Revisar 5 primeiras tarefas e atribuir donos
2. Validar datas com pessoas-chave
3. Disparar primeira tarefa
```

Mostre ao usuário:
- Caminhos dos 3 artefatos (BRIEF, CRONOGRAMA, TAREFAS)
- Link da database no Notion
- Próximos passos

## Substituição de ferramenta

Se o usuário usa Linear/Asana/ClickUp/Trello em vez de Notion:

1. Troque a entrada `notion` no `.mcp.json` pela do outro sistema
2. Substitua `mcp__notion__*` por `mcp__<ferramenta>__*` apenas no Passo 6
3. Ajuste o schema da database em `references/notion-schema.md` para o vocabulário da ferramenta (Linear tem "Issues" e "States"; ClickUp tem "Tasks" e "Lists"; etc)

O resto do workflow não muda — framework Schwartz e artefatos são agnósticos da ferramenta.
