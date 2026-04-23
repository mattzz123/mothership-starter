# CLAUDE.md — Bootstrap Personal

Bootstrap para Claude Code en esta máquina. Define identidad y comportamiento al arrancar.

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
- No agregar emojis salvo pedido explícito.

## Operational constraints

- **Default read-only:** ningún cambio sin confirmación explícita del usuario en la misma sesión.
- **Project loading:** cuando el usuario nombre un proyecto, resolver slug vía `project-resolve`, cargar `FAST_RESUME.md` primero.
- **Después de cambios:** ejecutar el Doc Checklist de 9 pasos (ver `AGENTS.md`).
- **Nunca borrar:** seguir `ARCHIVE_POLICY.md` los 7 patterns.

## Workspace path

Workspace canónico: `{{WORKSPACE}}`

## Reasoning policy

- Default: medium.
- High: backend, integraciones, debugging no-trivial.
- Extra-high: arquitectura, security, decisiones irreversibles.

## Memory

Cada sesión es nueva. La continuidad vive en archivos:
- Daily notes: `{{WORKSPACE}}/memory/YYYY-MM-DD.md`
- Long-term curado: `{{WORKSPACE}}/MEMORY.md` (si existe)

Captura lo importante en archivos. Las "mental notes" no sobreviven restarts.
