# Schema da Database de Campanha — Notion

Para uso pelo skill `lancar-campanha` no Passo 6.

## Database title

`Magnus — <slug-campanha>`

> Exemplo: `Magnus — q3-2026-aquecimento`

## Propriedades

| Nome | Tipo | Opções |
|------|------|--------|
| Tarefa | title | — |
| Status | select | `Backlog`, `Em andamento`, `Em revisão`, `Concluído`, `Bloqueado` |
| Etapa | select | `Aquecimento`, `Pré-lançamento`, `Abertura`, `Fechamento`, `Pós` |
| Tipo | select | `Copy`, `Criativo`, `Vídeo`, `Email`, `Anúncio`, `Operacional` |
| Dono | people | — |
| Data | date | — |
| Prioridade | select | `Alta`, `Média`, `Baixa` |
| Notas | rich_text | — |

## Como criar via MCP

```
mcp__notion__create_database(
  parent_id="<id-da-pagina-parent>",
  title="Magnus — <slug>",
  properties={
    "Tarefa": {"title": {}},
    "Status": {"select": {"options": [
      {"name": "Backlog"},
      {"name": "Em andamento"},
      {"name": "Em revisão"},
      {"name": "Concluído"},
      {"name": "Bloqueado"}
    ]}},
    "Etapa": {"select": {"options": [
      {"name": "Aquecimento"},
      {"name": "Pré-lançamento"},
      {"name": "Abertura"},
      {"name": "Fechamento"},
      {"name": "Pós"}
    ]}},
    "Tipo": {"select": {"options": [
      {"name": "Copy"},
      {"name": "Criativo"},
      {"name": "Vídeo"},
      {"name": "Email"},
      {"name": "Anúncio"},
      {"name": "Operacional"}
    ]}},
    "Dono": {"people": {}},
    "Data": {"date": {}},
    "Prioridade": {"select": {"options": [
      {"name": "Alta"},
      {"name": "Média"},
      {"name": "Baixa"}
    ]}},
    "Notas": {"rich_text": {}}
  }
)
```

## Views recomendadas

Crie depois manualmente no Notion (MCP não suporta criação de views diretamente):

- **Kanban por Status** — para o time visualizar trabalho em andamento
- **Calendar por Data** — visão temporal
- **Timeline por Etapa** — visão macro do lançamento
- **Filtered: Minhas tarefas** — filtro por dono
- **Filtered: Esta semana** — date filter "Data is within this week"
