# Mothership Method — Cheatsheet

**Imprimí esto. Pegalo al monitor. Es todo lo que necesitás.**

---

## Los 5 archivos de cada proyecto

| Archivo | Para qué |
|---|---|
| `FAST_RESUME.md` | Estado ACTUAL (≤3KB). Lo primero que la IA lee. |
| `SUMMARY.md` | Arquitectura estable (≤5KB). Casi no cambia. |
| `NEXT.md` | Backlog activo (≤2KB). Lo próximo a hacer. |
| `LOG.md` | Historia narrativa (sin límite). Append-only. |
| `INDEX.md` | Mapa interno (paths, secrets, backups). |

---

## Los 4 archivos del workspace global

| Archivo | Para qué |
|---|---|
| `AGENTS.md` | Reglas del workspace. Lee cada agente al arrancar. |
| `CROSS_SYNC.md` | Log compartido entre agentes (Claude/Codex/Gemini). |
| `ARTIFACT_INDEX.md` | Mapa de scripts/configs/runtimes. |
| `PROJECT_REGISTRY.md` | Catálogo de tus proyectos con sus aliases. |

---

## Comandos esenciales

```bash
# Crear proyecto nuevo
project-init mi-proyecto

# Resolver alias a slug
project-resolve "mi proyecto"

# Validar checklist de documentación post-cambio
doc-close mi-proyecto

# Backup local del proyecto
project-sync mi-proyecto
```

---

## Las 4 fases de cada sesión

### 1. Slim Boot (al abrir la sesión)
La IA lee SOLO 2 archivos:
- `AGENTS.md`
- `CROSS_SYNC.md`

Cuando le decís en qué proyecto trabajar, lee `FAST_RESUME.md` de ese proyecto.

### 2. Trabajo
- Decile a la IA qué hacer.
- Si necesita más contexto, lee `SUMMARY.md`, `LOG.md` según haga falta.
- Para búsquedas grandes, que use subagentes (no quema context window).

### 3. Doc Checklist (después de CADA cambio importante)
9 pasos atómicos — ejecutar TODOS:

1. Backup `.bak.<UTC>` de archivos modificados.
2. Append entry a `CROSS_SYNC.md` (Actor / Scope / Change / Reason / Validation / Rollback).
3. Update `ARTIFACT_INDEX.md` si creaste/moviste artifact.
4. Update `FAST_RESUME.md` (estado actual).
5. Append a `LOG.md` (narrativa detallada).
6. Update `NEXT.md` (backlog realineado).
7. Update `SUMMARY.md` (solo si cambió arquitectura estable).
8. `project-sync <slug>` (backup).
9. Notes del día en `memory/YYYY-MM-DD.md` (opcional).

**Atajo:** `doc-close mi-proyecto` valida que hayas hecho todos los pasos.

### 4. Handoff (al cerrar)
No hacés nada — `FAST_RESUME.md` ya está actualizado. Mañana abrís y la IA sabe.

---

## Budgets que NO podés exceder

| Archivo | Límite |
|---|---|
| FAST_RESUME.md | ≤3KB / ≤60 líneas |
| SUMMARY.md | ≤5KB / ≤100 líneas |
| NEXT.md | ≤2KB / ≤40 líneas |
| LOG.md | sin límite |

**Si excede:** mover lo más viejo a `LOG.md` con header `## migrated YYYY-MM-DDTHH:MMZ`.

---

## Archive Policy — los 7 patterns (NUNCA borres)

1. Archivo desactivado → rename `.deprecated.<UTC>`
2. Directorio stale → mover a `_archive_<UTC>/`
3. Data periódica → rotar a `<categoría>/archive/<YYYY-MM>/`
4. Trim de archivo workspace → preservar `<name>_ARCHIVE.md`
5. Pre-edit de operacional → `.bak.<UTC>` mandatorio
6. Overflow de bundle → migrar a `LOG.md`
7. Lifecycle → status downgrade en `ARTIFACT_INDEX` (no remover)

**Excepciones `rm`:** `/tmp/**`, `__pycache__/`, `node_modules/`, lock files. Todo lo demás se archiva.

---

## Frase mnemotécnica

> **"La IA es stateless. La memoria vive en archivos. Yo escribo. Yo decido."**
