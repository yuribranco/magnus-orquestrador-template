# Orquestrador Empresarial — Template Magnus

Template Claude Code para transformar sua empresa em um sistema orquestrado por IA. Três skills prontos: criar criativos visuais, criar posts com design system, lançar campanhas com framework Schwartz.

## O que você ganha

- **criar-criativo** — descreva a campanha, Claude gera 3 conceitos, você aprova, e ele renderiza criativos em 1:1 (feed) e 9:16 (story) via Gemini 2.5 Flash Image.
- **criar-post** — copy + design no Canva, com seu Brand Kit aplicado automaticamente.
- **lancar-campanha** — entrevista Schwartz (10 perguntas), gera BRIEF + CRONOGRAMA + TAREFAS e popula database no Notion.

## Setup (5 minutos)

### 1. Pegue o template

**Opção A — ZIP (usado na mentoria):** descompacte `magnus-orquestrador-template.zip` e renomeie a pasta com o nome da sua empresa:

```bash
unzip magnus-orquestrador-template.zip
mv magnus-orquestrador-template minha-empresa
cd minha-empresa
```

**Opção B — clone:**

```bash
git clone https://github.com/yuribranco/magnus-orquestrador-template minha-empresa
cd minha-empresa
```

### 2. Configure o `.env`

```bash
cp .env.example .env
```

Edite e cole sua `GEMINI_API_KEY` do Google AI Studio (https://aistudio.google.com/apikey). O free tier do Flash dá ~1.500 requests/dia, mais que suficiente pra começar.

### 3. Abra o Claude Code

```bash
claude
```

### 4. Autentique os MCPs

```
/mcp
```

Vai abrir o navegador 2x. Autorize Canva e Notion.

> Caveat: se o OAuth do Notion falhar com "Invalid redirect_uri", atualize seu Claude Code (`claude --version` precisa ser >= 2.1.119).

### 5. Customize seu contexto

Edite os 4 arquivos em `contexto/`:

- `EMPRESA.md` — quem você é, ICP, ofertas
- `TIME.md` — pessoas e papéis
- `VOZ.md` — como você escreve
- `DESIGN.md` — como você aparece

Coloque logos, fontes e fotos em `contexto/ativos/`.

### 6. Configure seu Brand Kit no Canva

Entre em https://canva.com/brand e cadastre cores, fontes e logo. Documente os nomes no `contexto/DESIGN.md` para o Claude referenciar.

### 7. Crie sua primeira iniciativa

Cada **iniciativa** (campanha, funil, lançamento) vive numa pasta própria em `operacao/<slug>/` com um `BRIEFING.md` (oferta, avatar, ângulo). Sua empresa — voz e design — fica em `contexto/`, **compartilhada por todas**. Você roda quantas iniciativas quiser em paralelo (ex: um low-ticket E um lançamento).

Crie, por exemplo, `operacao/lancamento-q1/BRIEFING.md` com a oferta, o avatar e o ângulo.

### 8. Use

Em qualquer sessão Claude Code dentro do projeto, fale em linguagem natural:

```
> quero criar um criativo de anúncio pra [iniciativa] sobre [tema]
> quero criar a landing page de [iniciativa]
> me ajuda a fazer um carrossel sobre [tema] pra LinkedIn
> vou lançar [produto] em [data], me ajuda a estruturar
```

O skill correto ativa sozinho e salva em `operacao/<iniciativa>/`.

## Trocar Notion por outro gerenciador

Edite `.mcp.json`. Troque a URL `notion` pela do MCP da sua ferramenta (Linear, Asana, ClickUp). No `lancar-campanha/SKILL.md`, substitua `mcp__notion__*` por `mcp__<ferramenta>__*` apenas no Passo 6 (Notion). Resto continua igual.

## Estrutura

```
contexto/        → o que sua empresa É (voz, design, time — compartilhado)
.claude/         → o que sua empresa FAZ (skills prontos)
operacao/<slug>/ → cada iniciativa (campanha/lançamento) com seu BRIEFING.md + assets
```

## Suporte

Issues técnicas no template: https://github.com/yuribranco/magnus-orquestrador-template
