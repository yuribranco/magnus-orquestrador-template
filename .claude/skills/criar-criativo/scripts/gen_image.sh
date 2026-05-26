#!/usr/bin/env bash
#
# Gera imagem via Gemini 2.5 Flash Image (Nano Banana).
# Uso: gen_image.sh "<prompt>" "<aspect_ratio>" "<output_path>"
# Exemplo: ./gen_image.sh "Family at sunset, cinematic" "9:16" "./out.png"
#
# Aspect ratios suportados: 1:1, 2:3, 3:2, 3:4, 4:3, 4:5, 5:4, 9:16, 16:9, 21:9

set -euo pipefail

if [ "$#" -ne 3 ]; then
  echo "Uso: $0 <prompt> <aspect_ratio> <output_path>" >&2
  exit 1
fi

PROMPT="$1"
RATIO="$2"
OUT="$3"

# Carrega .env da raiz do projeto se existir
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
if [ -f "${ROOT}/.env" ]; then
  set -a
  # shellcheck disable=SC1091
  source "${ROOT}/.env"
  set +a
fi

if [ -z "${GEMINI_API_KEY:-}" ]; then
  echo "Erro: GEMINI_API_KEY não definida. Configure em ${ROOT}/.env" >&2
  exit 1
fi

# Monta payload JSON com jq para evitar problemas de escape.
# aspectRatio vai em generationConfig.imageConfig (forma GA do 2.5 Flash Image).
PAYLOAD=$(jq -n \
  --arg prompt "$PROMPT" \
  --arg ratio "$RATIO" \
  '{
    contents: [{parts: [{text: $prompt}]}],
    generationConfig: {
      responseModalities: ["IMAGE"],
      imageConfig: {aspectRatio: $ratio}
    }
  }')

# Chama API e extrai imagem
RESPONSE=$(curl -sS -X POST \
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-image:generateContent" \
  -H "x-goog-api-key: ${GEMINI_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD")

# Detecta erro de API antes de tentar decodificar
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  echo "Erro da API Gemini:" >&2
  echo "$RESPONSE" | jq '.error' >&2
  exit 1
fi

# Extrai e salva. A resposta REST usa inlineData (camelCase); mantemos
# fallback para inline_data por robustez entre versões da API.
mkdir -p "$(dirname "$OUT")"

echo "$RESPONSE" \
  | jq -r '.candidates[0].content.parts[] | select(.inlineData // .inline_data) | (.inlineData // .inline_data).data' \
  | base64 --decode > "$OUT"

if [ -s "$OUT" ]; then
  SIZE=$(wc -c < "$OUT" | tr -d ' ')
  echo "OK: ${OUT} (${SIZE} bytes, ratio ${RATIO})"
else
  echo "Erro: arquivo vazio. Resposta completa da API:" >&2
  echo "$RESPONSE" >&2
  exit 1
fi
