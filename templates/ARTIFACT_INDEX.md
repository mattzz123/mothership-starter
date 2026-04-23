# ARTIFACT_INDEX.md — Mapa de artifacts del workspace

Catalogo de scripts, configs, runtimes, hooks, y herramientas operativas. Se actualiza cada vez que se crea/mueve/desactiva algo importante.

## Scripts del workspace

| Artifact | Path | Propósito |
|---|---|---|
| `project-init` | `~/bin/project-init` | Crea bundle nuevo de proyecto |
| `project-sync` | `~/bin/project-sync` | Backup local del bundle |
| `project-resolve` | `~/bin/project-resolve` | Resuelve alias a slug canonical |
| `doc-close` | `~/bin/doc-close` | Valida checklist de documentación post-cambio |

## Hooks Claude Code

| Hook | Path | Trigger | Función |
|---|---|---|---|
| `bash-budget-guard` | `~/.claude/hooks/bash-budget-guard.sh` | PreToolUse Bash | Bloquea comandos token-expensive |
| `doc-checklist-guard` | `~/.claude/hooks/doc-checklist-guard.sh` | Stop | Alerta si bundle fue tocado sin checklist |

## Search roots y patterns

- Proyectos: `projects/<slug>/`
- Memory daily: `memory/YYYY-MM-DD.md`
- Backups: `*.bak.<UTC>` (siempre junto al original)
- Archived: `_archive_<UTC>/` (siblings del directorio archived)
- Deprecated configs: `*.deprecated.<UTC>`

## Cómo mantener este archivo

- Después de crear un script/hook nuevo: agregalo acá.
- Después de promover/desactivar algo: actualizá la fila (no la borres — downgrade el status).
- Para familias grandes (logs rotativos, backups históricos): agregá un search root, no enumeres archivo por archivo.
