#!/usr/bin/env bash
set -euo pipefail

# TeX Gyre Heros keeps Helvetica's advance widths but has very tight vertical
# metrics: hhea/typo are 729/-216 while accented caps reach +1148 and cedillas
# -307. Linux toolkits size line boxes from those metrics, so text looks
# cramped, sits high, and accents clip. Rewrite the vertical metrics in the
# user's copies; advance widths and outlines are left untouched. The defaults
# put the cap-height block in the middle of the line box (ascent - |descent| =
# cap height) and keep the full ink bounds visible.

usage() {
  cat <<'EOF'
Usage: patch-tex-gyre-heros.sh [--ascent N] [--descent N]

Rewrite TeX Gyre Heros vertical metrics in the installed fonts, in place, so
Linux UI toolkits get a usable line box. Units are font units (1000 per em)
and descent must be negative. The cap-height block is centred when
ascent - |descent| = 729.

Defaults: --ascent 1148 --descent -419 (1.567 em, full ink bounds, centred)
EOF
}

if [ "$(uname -s)" != Linux ]; then
  exit 0
fi

ascent=1148
descent=-419

while [ $# -gt 0 ]; do
  case "$1" in
    --ascent)
      ascent="${2:?--ascent needs a value}"
      shift 2
      ;;
    --descent)
      descent="${2:?--descent needs a value}"
      shift 2
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

case "$ascent" in
  '' | *[!0-9]*)
    echo "--ascent must be a positive integer" >&2
    exit 2
    ;;
esac

case "$descent" in
  -*) ;;
  *)
    echo "--descent must be negative, e.g. -300" >&2
    exit 2
    ;;
esac

case "${descent#-}" in
  '' | *[!0-9]*)
    echo "--descent must be a negative integer, e.g. -300" >&2
    exit 2
    ;;
esac

font_dirs=("$HOME/.local/share/fonts" "$HOME/.fonts")
fonts=()
for font_dir in "${font_dirs[@]}"; do
  for face in regular bold italic bolditalic; do
    font="$font_dir/texgyreheros-$face.otf"
    if [ -f "$font" ]; then
      fonts+=("$font")
    fi
  done
done

if [ ${#fonts[@]} -eq 0 ]; then
  echo "Skipping TeX Gyre Heros: no user-installed faces found" >&2
  exit 0
fi

if python3 -c 'import fontTools' >/dev/null 2>&1; then
  python_cmd=(python3)
elif command -v uv >/dev/null 2>&1; then
  python_cmd=(uv run --no-project --quiet --with fonttools python)
else
  echo "Skipping TeX Gyre Heros: python3 with fontTools or uv is required" >&2
  exit 0
fi

if ! "${python_cmd[@]}" - "$ascent" "$descent" "${fonts[@]}" <<'PY'; then
import os
import sys
from pathlib import Path

from fontTools.ttLib import TTFont

ascent = int(sys.argv[1])
descent = int(sys.argv[2])

if not 0 < ascent <= 32767:
    sys.exit("ascent must be between 1 and 32767")
if not -32768 <= descent < 0:
    sys.exit("descent must be between -32768 and -1")

target = (ascent, descent, 0, ascent, descent, 0, ascent, -descent)


def metrics(font):
    hhea = font["hhea"]
    os2 = font["OS/2"]
    return (
        hhea.ascent,
        hhea.descent,
        hhea.lineGap,
        os2.sTypoAscender,
        os2.sTypoDescender,
        os2.sTypoLineGap,
        os2.usWinAscent,
        os2.usWinDescent,
    )


for path in map(Path, sys.argv[3:]):
    font = TTFont(path)
    if metrics(font) == target:
        print(f"  already patched: {path.name}")
        font.close()
        continue

    hhea = font["hhea"]
    os2 = font["OS/2"]

    hhea.ascent = ascent
    hhea.descent = descent
    hhea.lineGap = 0
    os2.sTypoAscender = ascent
    os2.sTypoDescender = descent
    os2.sTypoLineGap = 0
    os2.usWinAscent = ascent
    os2.usWinDescent = -descent
    os2.fsSelection |= 1 << 7  # USE_TYPO_METRICS

    tmp = path.with_name(path.name + ".tmp")
    font.save(tmp)
    font.close()
    os.replace(tmp, path)
    print(f"  patched: {path.name}")
PY
  echo "Skipping TeX Gyre Heros: patching failed" >&2
  exit 0
fi

if command -v fc-cache >/dev/null 2>&1; then
  fc-cache -f >/dev/null 2>&1 || true
fi

echo "TeX Gyre Heros metrics set to $ascent/$descent (restart apps to reload)"
