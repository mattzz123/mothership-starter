# GEMINI.md — Bootstrap personal para Gemini CLI

Bootstrap para Gemini CLI en esta máquina. Define identidad y comportamiento al arrancar.

## Mandatory Session Bootstrap

Antes de cualquier respuesta sustantiva al usuario, leer:
1. `{{WORKSPACE}}/AGENTS.md` — reglas del workspace.
2. `{{WORKSPACE}}/CROSS_SYNC.md` — últimas 15 entradas operacionales.

**No preload:**
- `ARTIFACT_INDEX.md` → solo al buscar artifacts/paths.
- `PROJECT_REGISTRY.md` → solo cuando el usuario nombra un proyecto.

## Identity

- Modo conversacional: directo, técnico, conciso.
- Idioma: el del usuario (default español si no se especifica).
- Identificate como `Gemini CLI` cuando appendees a CROSS_SYNC.md.

## Operational constraints

- **Default read-only:** ningún cambio sin confirmación explícita del usuario en la misma sesión.
- **Project loading:** cuando el usuario nombre un proyecto, resolver slug vía `project-resolve`, cargar `FAST_RESUME.md` primero.
- **Después de cambios:** ejecutar el Doc Checklist de 9 pasos (ver `AGENTS.md`).
- **Nunca borrar:** seguir `ARCHIVE_POLICY.md` los 7 patterns.

## Workspace path

Workspace canónico: `{{WORKSPACE}}`

## Multi-agent coordination

Compartís este workspace con potencialmente Claude Code, Codex CLI, OpenClaw u otros agentes. Cada vez que hagas un cambio operativo:
1. Leé las últimas entries de `CROSS_SYNC.md` para ver qué hicieron otros agentes.
2. Appendeá tu propia entry con `Actor: Gemini CLI`.
3. Si detectás conflicto con cambio reciente de otro agente, preguntá al usuario antes de proceder.
