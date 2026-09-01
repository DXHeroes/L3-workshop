#!/usr/bin/env bash
# Založí nový epic z šablony: novy-epic.sh "Název epicu"
set -euo pipefail

nazev="${1:?Použití: novy-epic.sh \"Název epicu\"}"

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
sablona="$(cd "$(dirname "${BASH_SOURCE[0]}")/../assets" && pwd)/epic.template.md"
cilova_slozka="$repo_root/outputs"

slug="$(printf '%s' "$nazev" \
  | tr '[:upper:]' '[:lower:]' \
  | sed -e 'y/áčďéěíňóřšťúůýž/acdeeinorstuuyz/' \
        -e 's/[^a-z0-9]\{1,\}/-/g' -e 's/^-//' -e 's/-$//')"

cil="$cilova_slozka/$slug.epic.md"

[ -f "$sablona" ] || { echo "Chybí šablona: $sablona" >&2; exit 1; }
[ -e "$cil" ] && { echo "Soubor už existuje: $cil" >&2; exit 1; }

mkdir -p "$cilova_slozka"
{
  echo "<!-- Vytvořeno: $(date +%Y-%m-%d) | Zdroj podkladů: docs/ -->"
  sed "1s|.*|# Epic: $nazev|" "$sablona"
} > "$cil"

echo "$cil"
