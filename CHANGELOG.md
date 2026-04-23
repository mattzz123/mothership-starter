# Changelog — Mothership Method Starter Pack

Todos los cambios notables a este proyecto se documentan acá.

## [1.1.0] — 2026-04-22

### Agregado
- **Multi-agente universal:** instalador detecta y configura Claude Code, Codex CLI, Gemini CLI, OpenClaw automáticamente.
- **`AGENTS.md`** universal en raíz del paquete (estándar adoptado por Google/OpenAI/Factory/Sourcegraph/Cursor).
- **`BOOTSTRAP_FOR_AGENT.md`** — instrucciones específicas para que CUALQUIER agente IA se auto-instale al leer este archivo.
- **`INSTALL_VIA_AGENT.md`** — prompt copy-paste para usuarios sin conocimiento técnico (3 formas de instalar).
- **`templates/GEMINI.md`** — bootstrap específico para Gemini CLI.
- **`LICENSE`** — MIT con atribución sugerida.
- **`CHANGELOG.md`** — este archivo.
- **`.gitignore`** para distribución vía GitHub.

### Cambiado
- `install.sh` ahora detecta múltiples agentes simultáneamente y configura cada uno apropiadamente (no solo Claude Code).
- `README.md` reescrito con 3 vías de instalación (vía IA / one-line curl / manual).
- `METHOD.md` sanitizado de referencias a proyectos privados del autor.

### Compatibilidad
- Funciona con Claude Code, Codex CLI, Gemini CLI, OpenClaw, y cualquier agente que reconozca AGENTS.md.
- Linux + macOS soportados nativamente. Windows vía WSL.

## [1.0.0] — 2026-04-22

### Inicial
- Instalador `install.sh` con detección OpenClaw + Claude Code.
- Templates workspace (AGENTS.md, CROSS_SYNC.md, ARTIFACT_INDEX.md, PROJECT_REGISTRY.md, ARCHIVE_POLICY.md).
- Templates project-bundle (FAST_RESUME, SUMMARY, NEXT, LOG, INDEX, META.json).
- 4 scripts ejecutables: project-init, project-sync, project-resolve, doc-close.
- 2 hooks: bash-budget-guard, doc-checklist-guard.
- Demo project pre-armado.
- Documentación completa: README, METHOD, CHEATSHEET.
