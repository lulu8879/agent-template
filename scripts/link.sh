#!/usr/bin/env bash
# Links every rule in .agents/rules/ and skill in .agents/skills/ into each tool's folder,
# removes links whose target is gone, reports rules missing from GEMINI.md or AGENTS.md,
# and reports agents whose copies in .agents/, .claude/, .opencode/ are missing or differ.
# Usage: scripts/link.sh [--check]   (--check reports problems without changing anything)
set -euo pipefail
shopt -s nullglob
cd "$(dirname "$0")/.."

check=false
if [[ ${1:-} == --check ]]; then check=true; fi

problems=0
claude_changed=false

# link <path> <target>: make <path> a symlink to <target>
link() {
  local path=$1 target=$2
  if [[ -L $path && $(readlink "$path") == "$target" ]]; then return 0; fi
  if [[ -e $path && ! -L $path ]]; then
    echo "not a symlink, left alone: $path"
    problems=$((problems + 1))
    return 0
  fi
  if $check; then
    echo "missing or wrong: $path -> $target"
    problems=$((problems + 1))
    return 0
  fi
  mkdir -p "$(dirname "$path")"
  ln -sfn "$target" "$path"
  echo "linked: $path -> $target"
  if [[ $path == .claude/* ]]; then claude_changed=true; fi
}

# prune <dir>: remove links into .agents/ whose target no longer exists
prune() {
  local dir=$1 path
  for path in "$dir"/*; do
    if [[ ! -L $path || -e $path || $(readlink "$path") != ../../.agents/* ]]; then continue; fi
    if $check; then
      echo "dangling: $path"
      problems=$((problems + 1))
    else
      rm "$path"
      echo "removed: $path"
    fi
  done
}

for rule in .agents/rules/*.md; do
  name=$(basename "$rule" .md)
  link ".claude/rules/$name.md" "../../$rule"
  link ".cursor/rules/$name.mdc" "../../$rule"
  link ".github/instructions/$name.instructions.md" "../../$rule"

  if [[ -f GEMINI.md ]] && ! grep -qxF "@./$rule" GEMINI.md; then
    echo "GEMINI.md has no import for $rule"
    problems=$((problems + 1))
  fi
  if ! grep -qF "$rule" AGENTS.md; then
    echo "AGENTS.md \"More instructions\" table doesn't mention $rule"
    problems=$((problems + 1))
  fi
done

for skill in .agents/skills/*/; do
  name=$(basename "$skill")
  link ".claude/skills/$name" "../../.agents/skills/$name"
done

for dir in .claude/rules .cursor/rules .github/instructions .claude/skills; do
  prune "$dir"
done

# Agents keep one copy per tool with different frontmatter. Their bodies must match,
# except the tech lead's "Start agents with the … tool" line.
agent_body() {
  awk 'c >= 2 { print; next } /^---$/ { c++ }' "$1" | grep -v '^Start agents with the '
}

agent_dirs=()
for dir in .agents/agents .claude/agents .opencode/agents; do
  if [[ -d $dir ]]; then agent_dirs+=("$dir"); fi
done
agent_names=$(for dir in "${agent_dirs[@]}"; do for f in "$dir"/*.md; do basename "$f" .md; done; done | sort -u)
for name in $agent_names; do
  ref=""
  for dir in "${agent_dirs[@]}"; do
    file="$dir/$name.md"
    if [[ ! -f $file ]]; then
      echo "agent missing: $file"
      problems=$((problems + 1))
    elif [[ -z $ref ]]; then
      ref=$file
    elif ! diff -q <(agent_body "$ref") <(agent_body "$file") >/dev/null; then
      echo "agent body differs: $file vs $ref"
      problems=$((problems + 1))
    fi
  done
done

if $claude_changed; then
  echo "If your global gitignore ignores .claude, stage the new links with: git add -f .claude"
fi
if ((problems)); then
  echo "$problems problem(s) found"
  exit 1
fi
echo "All links OK"
