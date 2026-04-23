#!/usr/bin/env bash
# doc-checklist-guard.sh — Stop hook para Claude Code
# Alerta si la sesión tocó archivos de bundle pero NO ejecutó doc-close/project-sync.
# Instalar: configurar en ~/.claude/settings.json bajo hooks.Stop

set -uo pipefail

# Detectar workspace
WORKSPACE="${MOTHERSHIP_WORKSPACE:-}"
if [ -z "$WORKSPACE" ]; then
    for candidate in "$HOME/.openclaw/workspace" "$HOME/mothership-workspace"; do
        [ -d "$candidate" ] && WORKSPACE="$candidate" && break
    done
fi
[ -z "$WORKSPACE" ] && exit 0  # si no hay workspace, skip silenciosamente

# Leer input JSON del hook
INPUT="$(cat)"

# Extraer transcript_path del JSON (format: {"transcript_path": "...", ...})
TRANSCRIPT=$(echo "$INPUT" | grep -oE '"transcript_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"transcript_path"[[:space:]]*:[[:space:]]*"//; s/"$//')

# Si no hay transcript, buscar bundles modificados en últimos 30 min
MODIFIED_SLUGS=()
if [ -d "$WORKSPACE/projects" ]; then
    while IFS= read -r bundle; do
        SLUG=$(basename "$bundle")
        # Si algún archivo del bundle fue modificado en últimos 30 min
        if find "$bundle" -type f -name "*.md" -mmin -30 2>/dev/null | grep -q .; then
            # Y NO se corrió project-sync hace <30 min
            LAST_SYNC="$WORKSPACE/backups/$SLUG"
            if [ -d "$LAST_SYNC" ]; then
                LAST_BACKUP_AGE=$(find "$LAST_SYNC" -maxdepth 1 -mmin -30 2>/dev/null | head -1)
                if [ -z "$LAST_BACKUP_AGE" ]; then
                    MODIFIED_SLUGS+=("$SLUG")
                fi
            else
                MODIFIED_SLUGS+=("$SLUG")
            fi
        fi
    done < <(find "$WORKSPACE/projects" -maxdepth 1 -mindepth 1 -type d 2>/dev/null)
fi

if [ "${#MODIFIED_SLUGS[@]}" -gt 0 ]; then
    echo "🚫 doc-checklist-guard: sesión tocó bundle files para [ ${MODIFIED_SLUGS[*]} ] sin completar el checklist." >&2
    echo "" >&2
    echo "Antes de cerrar el turno, verificar y completar para cada slug:" >&2
    echo "  1. NEXT.md — ¿actualizado con nuevos pendientes?" >&2
    echo "  2. LOG.md  — ¿entrada detallada de la sesión?" >&2
    echo "  3. CROSS_SYNC.md — ¿entrada con Actor/Scope/Change/Reason/Validation/Rollback?" >&2
    echo "  4. FAST_RESUME.md — ¿refleja estado actual?" >&2
    echo "  5. project-sync <slug> — ¿corrido?" >&2
    echo "" >&2
    echo "Completar y volver a terminar el turno." >&2
    exit 2  # bloquea el Stop
fi

exit 0
