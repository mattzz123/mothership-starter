# AGENTS.md — Workspace Rules

Reglas que cada sesión de agente (Claude Code / Codex / Gemini) sigue al arrancar.

## Slim Boot (mandatorio)

Antes de cualquier trabajo sustantivo, lee exactamente estos 2 archivos:
1. `AGENTS.md` — este archivo.
2. `CROSS_SYNC.md` — últimas entradas operacionales (ya trimmeado).

**Carga on-demand (no preload):**
- `ARTIFACT_INDEX.md` — solo cuando buscás artifacts/scripts.
- `PROJECT_REGISTRY.md` — solo cuando el usuario nombra un proyecto.
- `projects/<slug>/FAST_RESUME.md` — primero al cargar un proyecto.
- `projects/<slug>/SUMMARY.md`, `INDEX.md`, `NEXT.md` — solo si FAST_RESUME es insuficiente.

**Después del boot, siempre preguntá:** *"¿En qué proyecto desea trabajar hoy?"* si está ambiguo.

## Project loading

1. Resolver slug vía `PROJECT_REGISTRY.md` o el script `project-resolve <name>`.
2. Cargar `projects/<slug>/FAST_RESUME.md` primero (≤3KB).
3. Solo si necesario: `SUMMARY` → `INDEX` → `NEXT` → `LOG`.

## Doc Checklist (mandatorio post-cambio)

Después de CUALQUIER cambio operativo (bundle, script, config), ejecutar los 9 pasos:

1. Backup `.bak.<UTC>` de cada archivo modificado.
2. Append entry a `CROSS_SYNC.md`: Actor / Scope / Change / Reason / Validation / Rollback.
3. Update `ARTIFACT_INDEX.md` si se creó/movió artifact.
4. Update `projects/<slug>/FAST_RESUME.md` (estado actual, ≤3KB).
5. Append a `projects/<slug>/LOG.md` (timestamp + qué + por qué + validation + rollback).
6. Realinear `projects/<slug>/NEXT.md` (completados → LOG).
7. Update `projects/<slug>/SUMMARY.md` solo si cambió arquitectura estable.
8. Ejecutar `project-sync <slug>` para backup.
9. Notes del día en `memory/YYYY-MM-DD.md` (opcional).

**Excepción:** trabajo efímero en `/tmp` o dry-runs sin impacto real.

**Tool:** `doc-close <slug>` valida el checklist completo.

## Budget discipline

| Archivo | Budget |
|---|---|
| `FAST_RESUME.md` | ≤3KB / ≤60 líneas |
| `SUMMARY.md` | ≤5KB / ≤100 líneas |
| `NEXT.md` | ≤2KB / ≤40 líneas |
| `LOG.md` | sin límite |

**Si excede:** migrar oldest content a `LOG.md` con header `## <file-name> archive migrated YYYY-MM-DDTHH:MMZ`.

## Archive Policy (mandatorio)

Nunca `rm`. Siempre archivar. Los 7 patterns canónicos están en `ARCHIVE_POLICY.md`. Excepciones únicas: `/tmp/**`, `__pycache__/`, `node_modules/`, lock files.

## Tool output discipline

- Antes de leer archivo grande: `wc -c` primero.
- ≤3KB: leer completo.
- 3-50KB: `head -N` / `tail -N` / `sed -n 'a,bp'`.
- >50KB: `grep`/`rg` con keywords específicos.
- Logs: `tail -100` o `grep ERROR | tail -50`.
- JSON: `jq '.path'` no dump completo.

## Coordinación multi-agente

Si tenés varios agentes CLI (Claude Code + Codex + Gemini), todos leen el mismo `CROSS_SYNC.md`. Cada cambio cross-agent va con timestamp + actor:

```
### [YYYY-MM-DD HH:MM UTC] <slug>: <descripción corta>
- Actor: <agente>
- Scope: ...
- Change: ...
- Reason: ...
- Validation: ...
- Rollback: ...
```

## Safety

- Sin escribir secrets en chat, memory, o docs. Referenciar archivo controlador.
- Antes de operación destructiva: confirmar con usuario.
- Backup pre-edit obligatorio (`.bak.<UTC>`).
