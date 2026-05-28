#!/usr/bin/env bash
# Install gstack skills into this repo's .cursor/skills/ (project-local, not global).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GSTACK="${GSTACK:-$HOME/gstack}"
SKILLS_DIR="$ROOT/.cursor/skills"

if [ ! -d "$GSTACK/.cursor/skills" ]; then
  echo "Error: gstack not found at $GSTACK" >&2
  echo "Clone it first:" >&2
  echo "  git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git \"$GSTACK\"" >&2
  echo "  cd \"$GSTACK\" && ./setup && bun run gen:skill-docs --host cursor" >&2
  exit 1
fi

mkdir -p "$SKILLS_DIR"
CURSOR_GSTACK="$SKILLS_DIR/gstack"
rm -rf "$CURSOR_GSTACK"
mkdir -p "$CURSOR_GSTACK/browse" "$CURSOR_GSTACK/gstack-upgrade" "$CURSOR_GSTACK/review" "$CURSOR_GSTACK/design"

ln -snf "$GSTACK/bin" "$CURSOR_GSTACK/bin"
ln -snf "$GSTACK/browse/dist" "$CURSOR_GSTACK/browse/dist"
ln -snf "$GSTACK/browse/bin" "$CURSOR_GSTACK/browse/bin"
[ -d "$GSTACK/design/dist" ] && ln -snf "$GSTACK/design/dist" "$CURSOR_GSTACK/design/dist"
ln -snf "$GSTACK/.cursor/skills/gstack-upgrade/SKILL.md" "$CURSOR_GSTACK/gstack-upgrade/SKILL.md"
ln -snf "$GSTACK/ETHOS.md" "$CURSOR_GSTACK/ETHOS.md"
ln -snf "$GSTACK/VERSION" "$CURSOR_GSTACK/VERSION"
for f in checklist.md TODOS-format.md; do
  [ -f "$GSTACK/review/$f" ] && ln -snf "$GSTACK/review/$f" "$CURSOR_GSTACK/review/$f"
done
ln -snf "$GSTACK/.cursor/skills/gstack/SKILL.md" "$CURSOR_GSTACK/SKILL.md"

linked=0
for skill_dir in "$GSTACK/.cursor/skills"/gstack*/; do
  skill_name="$(basename "$skill_dir")"
  [ "$skill_name" = "gstack" ] && continue
  ln -snf "$skill_dir" "$SKILLS_DIR/$skill_name"
  linked=$((linked + 1))
done

echo "gstack ready (project-local)."
echo "  skills: $SKILLS_DIR"
echo "  runtime: $CURSOR_GSTACK"
echo "  linked: $linked skills from $GSTACK"
