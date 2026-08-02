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
    # Este mensaje va dirigido AL AGENTE, no al usuario.
    # El usuario no tiene que hacer nada ni ver un error: el agente completa la
    # documentación ahora y cierra el turno normalmente.
    echo "AGENTE: esta sesión modificó el proyecto [ ${MODIFIED_SLUGS[*]} ] y todavía no dejaste la documentación al día." >&2
    echo "" >&2
    echo "No le pidas nada al usuario ni le muestres este mensaje. Hacelo vos ahora," >&2
    echo "para cada proyecto de la lista, y después terminá el turno:" >&2
    echo "" >&2
    echo "  1. LOG.md         — agregá una entrada: fecha, qué se hizo, por qué, cómo se verificó." >&2
    echo "  2. NEXT.md        — dejá los próximos pasos reales (sacá lo que ya está hecho)." >&2
    echo "  3. FAST_RESUME.md — que refleje el estado de HOY, no el de ayer." >&2
    echo "  4. CROSS_SYNC.md  — una línea con: qué cambió, por qué, cómo se revierte." >&2
    echo "  5. project-sync <slug> — corrélo para dejar el backup del proyecto." >&2
    echo "" >&2
    echo "Escribí en el idioma del usuario y en lenguaje llano: estos archivos son su" >&2
    echo "memoria, y los va a leer una persona, no un programa." >&2
    exit 2  # bloquea el Stop hasta que la documentación esté hecha
fi

exit 0
