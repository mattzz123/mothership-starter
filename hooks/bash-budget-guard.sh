#!/usr/bin/env bash
# bash-budget-guard.sh — PreToolUse hook para Bash
# Bloquea comandos token-expensive que inflan el contexto de la IA innecesariamente.
# Instalar: configurar en ~/.claude/settings.json bajo hooks.PreToolUse.Bash

# Input: el hook recibe JSON via stdin con el tool_input
INPUT="$(cat)"
COMMAND="$(echo "$INPUT" | grep -oE '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"command"[[:space:]]*:[[:space:]]*"//; s/"$//')"

block() {
    local reason="$1"
    echo "BLOCKED by bash-budget-guard: $reason" >&2
    exit 2
}

# cat en archivos grandes o de tipos verbose
if echo "$COMMAND" | grep -qE '^\s*cat\s+[^|]+$'; then
    FILE=$(echo "$COMMAND" | sed -E 's/^\s*cat\s+//; s/\s*$//')
    if [ -f "$FILE" ]; then
        SIZE=$(wc -c < "$FILE" 2>/dev/null || echo 0)
        if [ "$SIZE" -gt 51200 ]; then
            block "cat en archivo >50KB. Usá 'head -N' / 'tail -N' / 'grep PATTERN' / Read tool con offset+limit."
        fi
    fi
fi

# cat de tipos siempre verbose
if echo "$COMMAND" | grep -qE 'cat\s+[^|]*\.(jsonl|log|ndjson)'; then
    block "cat en .jsonl/.log/.ndjson. Usá 'tail | jq' o 'grep | tail'."
fi

# find / sin maxdepth
if echo "$COMMAND" | grep -qE '^\s*find\s+/\s' && ! echo "$COMMAND" | grep -q 'maxdepth'; then
    block "find / sin -maxdepth. Agregá una profundidad máxima."
fi

# journalctl sin -n
if echo "$COMMAND" | grep -q 'journalctl' && ! echo "$COMMAND" | grep -qE '(\-n\s+[0-9]+|\-\-lines=[0-9]+)'; then
    block "journalctl sin -n N. Agregá un límite de líneas."
fi

# ls -R
if echo "$COMMAND" | grep -qE '^\s*ls\s+.*-[a-zA-Z]*R'; then
    block "ls -R es verbose. Usá 'find -maxdepth N' o subdirs específicos."
fi

# grep -r sin --include ni --exclude-dir
if echo "$COMMAND" | grep -qE '\bgrep\s+.*-r\b' && \
   ! echo "$COMMAND" | grep -qE '(\-\-include|\-\-exclude\-dir)'; then
    block "grep -r sin --include ni --exclude-dir. Usá 'rg PATTERN PATH' (respeta .gitignore) o agregá filtros."
fi

# git log sin -N
if echo "$COMMAND" | grep -qE '^\s*git\s+log\s' && ! echo "$COMMAND" | grep -qE '\-[0-9]+|\-\-max-count=[0-9]+'; then
    block "git log sin limit. Agregá '-N' (ej: git log --oneline -20)."
fi

# env / printenv sin grep
if echo "$COMMAND" | grep -qE '^\s*(env|printenv)\s*$'; then
    block "env/printenv sin grep. Usá 'env | grep PATTERN' para filtrar."
fi

exit 0
