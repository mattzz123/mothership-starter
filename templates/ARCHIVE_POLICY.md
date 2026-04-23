# ARCHIVE_POLICY.md — Los 7 patterns de retention

**Regla dura no-negociable: nada se borra. Nada. El verbo operacional es archivar, nunca borrar.**

Todos los agentes (Claude / Codex / Gemini) siguen exactamente la misma política — no hay asunciones individuales.

## Los 7 patterns canónicos

### 1. Archivo de config/unit que se desactiva
**Acción:** rename in-place a `<file>.deprecated.<UTC>`
**Ejemplo:** `service.config.json` → `service.config.json.deprecated.20260422T1400Z`
**Por qué:** preserva contenido + indica claramente que está deshabilitado + permite rollback.

### 2. Directorio de proyecto stale
**Acción:** mover a sibling `_archive_<UTC>/`
**Ejemplo:** `projects/old-thing/` → `projects/old-thing_archive_20260422T1400Z/`
**Por qué:** lo saca del workflow activo sin perder nada.

### 3. Data time-series periódica
**Acción:** rotar a `<categoría>/archive/<YYYY-MM>/`
**Ejemplo:** `logs/api-2026-04.log` → `logs/archive/2026-04/api.log`
**Por qué:** mantiene la query rápida en data activa, archive crece sin afectar performance.

### 4. Archivo workspace-level al trimmear
**Acción:** preservar original como `<name>_ARCHIVE.md`
**Ejemplo:** trimmeás `CROSS_SYNC.md` → guardás `CROSS_SYNC_ARCHIVE.md` antes
**Por qué:** las entradas viejas pueden ser load-bearing en debugging futuro.

### 5. Antes de editar archivo operacional
**Acción:** `.bak.<UTC>` mandatorio
**Ejemplo:** edit `AGENTS.md` → primero copiar a `AGENTS.md.bak.20260422T1400Z`
**Por qué:** rollback en 1 comando si rompiste algo.

### 6. Overflow en bundle doc
**Acción:** migrar a `projects/<slug>/LOG.md` con header fechado
**Ejemplo:** SUMMARY.md excede 5KB → mover oldest secciones a LOG.md con `## SUMMARY archive migrated 2026-04-22T14:00Z`
**Por qué:** mantiene budgets activos sin perder historia.

### 7. Tracking lifecycle
**Acción:** status downgrade en `ARTIFACT_INDEX.md` (nunca remover entry)
**Ejemplo:** script desactivado → cambia `status: active` a `status: deprecated` en el índice
**Por qué:** si alguien lo busca, encuentra la entrada con explicación de por qué ya no se usa.

## Excepciones (los únicos casos donde `rm` es OK)

- `/tmp/**`
- `.tmp.<random>`
- `__pycache__/`
- `*.pyc`
- `node_modules/`
- `.next/cache/`
- PID/lock files

**Todo lo demás se archiva.**

## Presión de disco

NUNCA `rm -rf` como respuesta a falta de espacio. En su lugar:
1. Comprimir (`tar --zstd`)
2. Mover a archive long-term (otro disco, S3, lo que sea)
3. Si urgente: consultar al operador antes de cualquier deletion

## Por qué esta política existe

Lo que hoy parece basura, mañana es **el contexto crítico** que necesitás para entender por qué tomaste una decisión. La memoria de tu workspace es tu segundo cerebro — borrar selectivamente equivale a daño cerebral por elección.
