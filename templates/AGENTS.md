# AGENTS.md — Workspace Rules (v1.1.1 light)

Reglas que cada sesión de agente (Claude Code / Codex / Gemini / OpenClaw / etc.) sigue al arrancar.

## Slim Boot

Antes de cualquier trabajo sustantivo, leé estos 2 archivos:
1. `AGENTS.md` (este archivo)
2. `CROSS_SYNC.md` (últimas entradas operacionales)

Cargá on-demand:
- `PROJECT_REGISTRY.md` cuando el usuario nombre un proyecto.
- `projects/<slug>/FAST_RESUME.md` al cargar un proyecto específico.
- `SUMMARY.md`, `LOG.md` solo si FAST_RESUME es insuficiente.

## Cargar un proyecto

1. Resolver slug vía `project-resolve <nombre>`.
2. Leer `projects/<slug>/FAST_RESUME.md` (≤3KB).
3. Solo si necesario: `SUMMARY` → `LOG`.

## Reglas de oro

### CREAR proyecto → siempre con scope completo

**NUNCA** ejecutes `project-init <slug>` sin `--scope` y `--alias`.

Si el usuario no te dio scope, preguntá ANTES de crear:
> "Para crear el proyecto necesito: (a) scope del proyecto, (b) aliases naturales, (c) título humano (opcional)."

Después ejecutá:
```bash
project-init <slug> --scope "..." --alias "..." --title "..."
```

El script hace todo: llena SUMMARY/FAST_RESUME/NEXT, agrega a PROJECT_REGISTRY, appendea CROSS_SYNC, corre project-sync.

### BORRAR → siempre archivar, nunca borrar

**NUNCA uses `rm`** sobre archivos del workspace. El verbo es **archivar**.

```bash
# ✅ Correcto
mv projects/<slug> projects/<slug>_archive_$(date -u +%Y%m%dT%H%MZ)/

# ❌ Prohibido
rm -rf projects/<slug>
```

Excepciones `rm` permitidas: `/tmp/**`, `__pycache__/`, `node_modules/`, lock files, `*.pyc`.

### CAMBIOS operativos → siempre documentar

Después de modificar archivos de un bundle:
1. Appendea entry timestamped a `projects/<slug>/LOG.md`.
2. Si el cambio es estructural (decisión de arquitectura, stack, scope), appendea también a `CROSS_SYNC.md` raíz.
3. Ejecutá `doc-close <slug>` para validar.

### EDITAR archivos del workspace → backup primero

Antes de editar `AGENTS.md`, `CROSS_SYNC.md`, `PROJECT_REGISTRY.md`, `ARTIFACT_INDEX.md`, `ARCHIVE_POLICY.md`:
```bash
cp <archivo> <archivo>.bak.$(date -u +%Y%m%dT%H%MZ)
```

### HONESTIDAD operativa

- **NUNCA** afirmes que ejecutaste algo sin verificarlo.
- Si falla, reportalo. No pretendas éxito.
- Si no sabés cómo, preguntá. No inventes.

## Budgets de tamaño

| Archivo | Budget | Si excede |
|---|---|---|
| `FAST_RESUME.md` | ≤3KB / ≤60L | Migrar oldest content a `LOG.md` |
| `SUMMARY.md` | ≤5KB / ≤100L | Migrar oldest content a `LOG.md` |
| `NEXT.md` | ≤2KB / ≤40L | Migrar completados a `LOG.md` |
| `LOG.md` | sin límite | Append-only forever |

## Comandos disponibles

| Comando | Para qué |
|---|---|
| `project-init <slug> --scope "..." --alias "..." --title "..."` | Crear proyecto completo |
| `project-resolve <nombre>` | Resolver alias a slug canonical |
| `project-sync <slug>` | Backup local del bundle |
| `doc-close <slug>` | Validar checklist de documentación |

## Multi-agente (opcional)

Si el usuario tiene múltiples agentes CLI (Claude + Codex + Gemini + OpenClaw), todos comparten este workspace. Cuando hacés un cambio, identificate al appendear a `CROSS_SYNC.md`:
- `Actor: Claude Code (claude-opus-4-7)`
- `Actor: Codex CLI`
- `Actor: Gemini CLI`
- `Actor: OpenClaw + Codex (Jarvis 2.0)`

Esto permite que otros agentes te identifiquen si tu cambio rompe algo.

## Safety

- Sin escribir secrets en chat, memory, o docs. Referenciar archivo controlador.
- Antes de operación destructiva: confirmar con el usuario.
- Backup pre-edit obligatorio (`.bak.<UTC>`).
