---
name: criar-landing
description: Cria uma landing page completa e on-brand (HTML standalone) unindo copy de resposta direta, o design system da empresa e inteligência de UI. Faz diagnóstico de oferta/ângulo, escreve a copy por seção (hero, problema, mecanismo, oferta, prova, CTA, FAQ), aplica os tokens de contexto/DESIGN.md + logo real, e renderiza um preview. Use sempre que o usuário pedir "criar landing", "landing page", "página de vendas", "página de captura", "página da oferta" ou similar.
allowed-tools: Read, Write, Glob, Bash(mkdir -p *), Bash(date:*), Bash(./.claude/skills/criar-criativo/scripts/render_html.sh:*)
---

# Skill: Criar Landing Page

Monta uma landing page completa — HTML standalone, responsiva, **100% on-brand** — unindo três camadas:
**copy** (resposta direta) + **design system** (`contexto/DESIGN.md`) + **UI** (layout/hierarquia).

## Antes de tudo — Bloco de Marca (skill `checar-marca`)
Carregue os tokens exatos via `checar-marca`: paleta (HEX), tipografia, logo de `contexto/ativos/`, voz, proibições.

## Camada de COPY — escolha a ferramenta
- **Se o copy-chief-black estiver instalado** (`npx @lucapimenta/copy-chief-black install-all`): invoque **`/cc`** (o "Chief"), o entrypoint único — ex: `/cc escreva a copy da landing da oferta <X>`. Ele roteia internamente (research → briefing → produção) e devolve copy de produção com mecanismo único e gates. **Não invoque os sub-agentes direto — só o `/cc`.**
- **Senão:** use o framework Schwartz (skill `/ba` do gstack se houver) — diagnóstico (mass desire · awareness · sophistication) → ângulo → copy por seção.

## Camada de DESIGN
- **Se tiver `/ui-ux-pro-max`** (gstack): use pra layout, hierarquia, font pairing, spacing.
- Tokens SEMPRE de `contexto/DESIGN.md` (HEX + fontes via Google Fonts) + logo real de `contexto/ativos/`.

## Workflow

### Passo 1 — Contexto + oferta
Leia `contexto/` (EMPRESA, VOZ, DESIGN, ativos). Pergunte UMA por vez: oferta/produto · público (stage of awareness) · promessa principal · preço/bônus/garantia · CTA principal · que prova existe (depoimentos?).

### Passo 2 — Copy por seção
Estrutura modular (ajuste a extensão à awareness — baixa = long copy que educa a dor; alta = short copy):
1. **Hero** — headline (do diagnóstico) + subhead + CTA primária
2. **Problema** — na linguagem real do avatar
3. **Mecanismo único** — por que funciona (vem ANTES do benefício)
4. **Oferta** — produto, bônus, garantia, escassez (Hormozi: menos esforço × mais resultado/certeza)
5. **Prova** — depoimentos reais ou `[A PREENCHER]` (NUNCA inventar)
6. **CTA** — específico (nunca "saiba mais")
7. **FAQ / objeções**
Apresente a copy. Espere aprovação antes de montar o HTML.

### Passo 3 — Montar o HTML
Produza um `index.html` standalone em `operacao/projetos/<slug>/landing/`:
- CSS vars com os **HEX exatos** do DESIGN.md; **fontes Google Fonts** do trio da marca; **logo real** de `ativos/`.
- Semântico, **mobile-first** responsivo, **uma única CTA primária** por viewport, whitespace generoso.
- Sem dependências além de Google Fonts. Sem emoji, sem gradiente fora do design, respeitar a proporção cromática.

### Passo 4 — Preview + QC
Renderize um preview com `render_html.sh` (ex.: `1440 2400` pra um corte alto) e abra com `Read` pra conferir.
Rode o checklist da `checar-marca`. Qualquer desvio do design system → ajuste antes de "pronto".

### Passo 5 — Entregar
Salve `index.html` + `copy.md` (copy fonte) + `README.md` (oferta + status). Mostre o caminho + o preview.

## Nota
A landing é um **arquivo HTML standalone** (deploy em qualquer host estático). O `criar-criativo` faz as peças
de imagem; o `criar-post` faz posts; este faz a página inteira. Todos puxam o mesmo `contexto/DESIGN.md`.
