# Changelog — Mothership Method Starter Pack

Todos los cambios notables a este proyecto se documentan acá.

## [1.1.3] — 2026-04-23

### Protecciones contra re-distribución no autorizada

**Problema:** el repo es público en GitHub. Cuando se le pasa el link al cliente vía Telegram, el cliente puede compartir el link con otros, o guardar el tar.gz para distribuirlo.

### Fix #1 — Self-destruct post-install
- `install.sh` ahora ejecuta `self_destruct()` al final de la instalación.
- Borra: el directorio `starter-pack/` (source code), tar.gz descargado en `~/`, `/tmp/`, y cualquier `~/mothership-starter*` (de git clone).
- Resultado: la instalación queda funcional (binarios en `~/bin`, templates en `~/.mothership/`, workspace configurado) PERO el source crudo desaparece.
- Cliente NO puede compartir el tar.gz porque ya no lo tiene.

### Fix #2 — Bot borra mensajes de Telegram con link al repo
- `BOOTSTRAP_FOR_AGENT.md` agrega Paso 8: el bot debe intentar borrar los mensajes del chat que contienen la URL del release.
- Usa la API de Telegram (`deleteMessage`) con el token guardado en `~/.openclaw/secrets/telegram.token`.
- Si NO puede borrar, lo reporta honestamente al usuario para que borre manual.
- Limpia rastros del link en el historial del chat para que el cliente no pueda re-compartirlo.

### Caveat honesto
- Estas protecciones reducen pero NO eliminan el riesgo de redistribución.
- Si el cliente tomó screenshot o copió el link antes de que el bot borre, sigue siendo replicable.
- La protección real está en el **valor del servicio** (onboarding + soporte), no en proteger el código (que igual es relativamente simple de replicar leyendo METHOD.md).
- Para enforcement fuerte se necesita repo privado + tokens efímeros + servidor de descarga propio (próxima iteración v1.2.0).

## [1.1.2] — 2026-04-23

### Fixes basados en testing end-to-end real (8 tests con prompts naturales)

**Problema detectado en v1.1.1:** el script `project-init` permitía crear bundle sin `--scope` (solo emitía warning). El bot ejecutaba `project-init <slug>` sin preguntar al usuario y dejaba el proyecto en placeholder. La regla en AGENTS.md "preguntá antes" era ignorada porque no había enforcement.

### Fix #1 — `--scope` ahora es OBLIGATORIO en `project-init`
- Si se omite `--scope`, script falla con error explícito y NO crea el bundle.
- Mensaje de error explica al agente IA: "preguntale al usuario por el scope antes de ejecutar".
- Esto fuerza al bot a hacer la pregunta correcta sin depender solo de la regla en AGENTS.md.

### Fix #2 — Regla léxica explícita: "archivar" no "borrar"
- `templates/AGENTS.md` y `BOOTSTRAP_FOR_AGENT.md` ahora prohíben palabras *"borrar", "eliminar", "delete", "remove"* en respuestas al usuario.
- Verbo correcto: *"archivar", "mover a archive", "deshabilitar"*.
- Razón: las palabras destructivas reducen confianza del usuario, aunque internamente el agente archive correctamente.

## [1.1.1] — 2026-04-23

### Cambios críticos basados en testing real con cliente piloto

**Problema detectado en v1.1.0:** cuando el usuario pedía "creá un proyecto X" sin más detalle, el bot ejecutaba `project-init` que solo creaba bundle vacío con templates. El bot luego NO completaba SUMMARY/FAST_RESUME/CROSS_SYNC manualmente (interpretaba selectivamente las reglas del método).

### Fix #1 — `project-init` rediseñado para hacer TODO determinísticamente
- Acepta flags `--scope`, `--alias`, `--title`.
- Llena SUMMARY.md, FAST_RESUME.md, NEXT.md, LOG.md, INDEX.md, META.json con info real (no placeholders).
- Agrega entry a PROJECT_REGISTRY.md con scope + aliases.
- Appendea entry a CROSS_SYNC.md documentando la creación.
- Ejecuta project-sync automáticamente.
- Si se omite `--scope`, emite WARNING explícito.

### Fix #2 — `BOOTSTRAP_FOR_AGENT.md` con playbook obligatorio
- Reglas de oro explícitas: cuando crees proyecto, NUNCA omitir scope/alias.
- Workflow obligatorio: preguntar primero, después ejecutar con flags.
- Verbo operativo: "archivar" siempre, NUNCA "borrar".
- Backup pre-edit mandatorio.
- Honestidad operativa: NUNCA pretender éxito sin verificación.

### Fix #3 — `templates/AGENTS.md` mucho más conciso
- Saca 9-step doc checklist (delegado al script `project-init` y `doc-close`).
- Mantiene: cómo cargar bundle, reglas de oro, comandos, budgets, safety.
- 60% menos texto. Más fácil de seguir para agente típico.
- "NUNCA borro, siempre archivo" explícito.

### Mejoras menores
- Templates project-bundle: placeholders más claros sobre qué llenar.
- Mensajes de project-init: salida estructurada con detalles del proyecto creado.

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
