#!/usr/bin/env bash
#
# Renderiza um arquivo HTML em PNG de dimensão exata, via Chrome/Chromium headless.
# Caminho "pixel-perfect": cor, fonte e logo saem exatos (sem aproximação de IA).
#
# Uso: render_html.sh <html_file> <output_png> <width> <height>
# Ex.: ./render_html.sh creative_1x1.html out_1x1.png 1080 1080

set -euo pipefail

if [ "$#" -ne 4 ]; then
  echo "Uso: $0 <html_file> <output_png> <width> <height>" >&2
  exit 1
fi

HTML="$1"; OUT="$2"; W="$3"; H="$4"

# Detecta o binário do Chrome/Chromium (macOS e Linux)
CHROME=""
for c in \
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  "/Applications/Chromium.app/Contents/MacOS/Chromium" \
  "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser" \
  "$(command -v google-chrome 2>/dev/null || true)" \
  "$(command -v chromium 2>/dev/null || true)" \
  "$(command -v chromium-browser 2>/dev/null || true)"; do
  if [ -n "$c" ] && [ -x "$c" ]; then CHROME="$c"; break; fi
done

if [ -z "$CHROME" ]; then
  echo "Erro: Chrome/Chromium não encontrado. Instale o Google Chrome para o render HTML." >&2
  exit 1
fi

# URL file:// absoluta
case "$HTML" in
  /*) HTML_URL="file://$HTML" ;;
  *)  HTML_URL="file://$(pwd)/$HTML" ;;
esac

mkdir -p "$(dirname "$OUT")"

# --virtual-time-budget dá tempo pras Google Fonts carregarem antes do screenshot
"$CHROME" --headless=new --disable-gpu --allow-file-access-from-files \
  --force-device-scale-factor=1 --hide-scrollbars \
  --window-size="${W},${H}" --virtual-time-budget=5000 \
  --screenshot="$OUT" "$HTML_URL" >/dev/null 2>&1 || true

if [ -s "$OUT" ]; then
  echo "OK: ${OUT} (${W}x${H})"
else
  echo "Erro: render falhou (arquivo vazio). Confira o HTML e se o Chrome está instalado." >&2
  exit 1
fi
