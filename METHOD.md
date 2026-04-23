# Mothership Method — Guía del usuario

**Sistema de memoria persistente para usuarios serios de OpenClaw / Claude Code / Codex / Gemini.**

Versión 1.0.0 starter — abril 2026.
Para uso personal. Re-distribución comercial requiere licencia.

---

## Por qué existe este método

Los modelos de lenguaje (Claude, GPT, Gemini) son **stateless** — no recuerdan nada entre sesiones. Cada vez que abrís una ventana nueva, arranca en cero.

Las "memory features" nativas (ChatGPT Memory, Claude Memory, Cursor Rules) **fallan en uso real** porque son listas de bullets opacas que no entienden cuándo algo cambió.

El Mothership Method resuelve esto trasladando la memoria a **archivos markdown estructurados que vos controlás**. La IA lee esos archivos al empezar cada sesión y sabe exactamente dónde quedaste.

---

## Las 3 reglas duras

1. **Nada se borra.** Todo se archiva.
2. **Nada se asume.** Se documenta explícitamente.
3. **La disciplina es humana.** Los hooks ayudan; vos decidís qué importa.

---

## Las 3 capas de memoria

### Capa A — Workspace global
Archivos que viven en la raíz de tu workspace (`~/mothership-workspace/` o `~/.openclaw/workspace/`).

| Archivo | Rol |
|---|---|
| `AGENTS.md` | Reglas que TODA sesión sigue. |
| `CROSS_SYNC.md` | Log compartido entre agentes (Claude/Codex/Gemini). |
| `ARTIFACT_INDEX.md` | Dónde vive cada script/config/runtime. |
| `PROJECT_REGISTRY.md` | Lista de tus proyectos con sus aliases. |
| `ARCHIVE_POLICY.md` | Los 7 patterns de archivado. |

### Capa B — Por proyecto (bundles)
Cada proyecto tiene su carpeta en `projects/<slug>/`.

| Archivo | Budget | Rol |
|---|---|---|
| `FAST_RESUME.md` | ≤3KB | Lo primero que la IA lee. Estado actual + último cambio + próximo paso. |
| `SUMMARY.md` | ≤5KB | Arquitectura estable. Casi no cambia. |
| `NEXT.md` | ≤2KB | Backlog activo. 3-8 items máximo. |
| `LOG.md` | sin límite | Historia narrativa append-only. |
| `INDEX.md` | — | Mapa interno (paths, secrets, backups). |

### Capa C — Memoria personal del agente (opcional)
Si usás Claude Code, podés tener `~/.claude/projects/<dir>/memory/` con notas que el agente lee automáticamente.

---

## Las 4 fases operativas

### Fase 1 — Slim Boot (cada vez que abrís la sesión)
Agente lee solo 2 archivos: `AGENTS.md` + `CROSS_SYNC.md` (≈ 3-5KB total).

Cuando le decís en qué proyecto trabajar, lee `FAST_RESUME.md` (≤3KB).

**Resultado:** sesión arranca con 5-8KB cargados, nunca pierde la cache de prompt.

### Fase 2 — Trabajo
- La IA ejecuta lo que le pidas.
- Si necesita más contexto: lee `SUMMARY` o `LOG`.
- Para exploraciones grandes: usa subagentes (no quema tu context window principal).

### Fase 3 — Doc Checklist (después de cada cambio importante)
**9 pasos atómicos. Hacelos TODOS o ninguno.**

1. **Backup** `.bak.<UTC>` de cada archivo modificado.
2. **CROSS_SYNC.md** entry: Actor / Scope / Change / Reason / Validation / Rollback.
3. **ARTIFACT_INDEX.md** update si se creó/movió artifact.
4. **FAST_RESUME.md** refleja estado actual (≤3KB).
5. **LOG.md** append entry detallada (timestamp + qué + por qué + validación + rollback).
6. **NEXT.md** realineado (lo completado va al LOG).
7. **SUMMARY.md** update solo si cambió arquitectura estable.
8. **project-sync** `<slug>` para backup.
9. **memory/YYYY-MM-DD.md** notas del día (opcional).

Atajo: `doc-close <slug>` valida que hiciste todos los pasos.

### Fase 4 — Handoff
No hacés nada. `FAST_RESUME.md` quedó actualizado.

Mañana, otra sesión, otra máquina, OTRO agente — todos arrancan leyendo `FAST_RESUME` y saben exactamente dónde quedaste. **Cero re-explicación.**

---

## Budget discipline (importante)

Los límites de tamaño no son sugerencia — son contrato:

- `FAST_RESUME ≤3KB`: si excede, la IA tarda más en arrancar y quema dinero. Migrá lo viejo al LOG.
- `SUMMARY ≤5KB`: si excede, dejaste de mantener arquitectura estable y empezaste a meter historia. Mové al LOG.
- `NEXT ≤2KB`: si excede, no es backlog activo — es lista interminable. Borrá completados (al LOG).

**El LOG no tiene límite porque ES el archive.** Append-only para siempre.

---

## Archive Policy — los 7 patterns

**Nunca uses `rm` excepto en archivos verdaderamente efímeros (`/tmp`, `__pycache__`, `node_modules`, lock files).** Todo lo demás se archiva:

1. **Archivo deshabilitado** → rename `<file>.deprecated.<UTC>`
2. **Directorio stale** → mover a sibling `_archive_<UTC>/`
3. **Data periódica** → rotar a `<category>/archive/<YYYY-MM>/`
4. **Trim de archivo workspace** → preservar original como `<name>_ARCHIVE.md`
5. **Pre-edit de archivo operacional** → `.bak.<UTC>` mandatorio
6. **Overflow de bundle doc** → migrar a `LOG.md` con header timestamped
7. **Lifecycle de tracking** → status downgrade en `ARTIFACT_INDEX` (no remover entry)

**Por qué importa:** lo que hoy parece basura, mañana es contexto crítico para entender por qué tomaste una decisión.

---

## Coordinación multi-agente (si usás varios CLI)

Los 3 agentes (Claude Code, Codex, Gemini) leen el MISMO `CROSS_SYNC.md`. Cuando uno hace un cambio:
- Append entry timestamped.
- Próximo agente que arranque lo ve.
- Cero conflicto, cero duplicación.

**Ejemplo:** Claude trabaja a las 14:00 en tu proyecto `web-app`. Codex arranca a las 16:00 en el mismo proyecto y ya sabe exactamente qué pasó porque lee `CROSS_SYNC` + `FAST_RESUME` actualizado.

---

## Cómo empezar (primer día)

1. Corré `./install.sh`.
2. Abrí Claude Code dentro de tu workspace.
3. Decile: *"trabajemos en mi-primer-proyecto"*.
4. Probá pedirle algo y ver cómo lee `FAST_RESUME.md`.
5. Hacé un cambio (cualquier cosa). Después corré `doc-close mi-primer-proyecto`.
6. Cerrá la sesión.
7. Mañana abrila de nuevo, decile *"qué estábamos haciendo"*. Te lo va a decir exactamente.

**Ese momento — cuando la IA te recuerda lo de ayer sin que vos le digas nada — es por qué este método existe.**

---

## Preguntas frecuentes

### "¿Por qué requiere disciplina humana?"
Porque la IA no sabe qué es importante para vos. Vos sí. La disciplina es donde está el valor — produce documentos de alta señal, no auto-compactación de basura.

### "¿Por qué no tiene UI gráfica?"
Porque queremos que tus archivos vivan en TU disco, legibles por CUALQUIER agente, hoy y en 5 años. Sin app, sin lock-in. Markdown plano + filesystem.

### "¿Tiene curva de aprendizaje?"
Sí. Es ~30 conceptos interconectados. Pero la curva se amortiza en 2 semanas de uso real, y queda como disciplina interiorizada para siempre.

### "¿Funciona con un solo agente?"
Sí. La capa multi-agente es opcional. Podés usarlo solo con Claude Code y va a funcionar igual.

### "¿Y si me olvido de hacer el doc checklist?"
El hook `doc-checklist-guard` te avisa al cerrar la sesión. Si lo configurás, no podés cerrar sin completarlo.

---

## Soporte

Lo que viene en tu compra:
- Acceso a este starter pack.
- Call de instalación 45 min en español.
- Video walkthrough.
- Cheatsheet PDF.
- 30 días soporte por WhatsApp.
- Acceso al Discord del grupo.

---

**Versión 1.0.0 starter pack — abril 2026.**
