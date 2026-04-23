# AGENTS.md — Mothership Method Bootstrap (universal)

> **Estás leyendo el archivo que CUALQUIER agente IA debe leer al entrar en este repositorio.**
> AGENTS.md es el estándar abierto adoptado por Google, OpenAI, Factory, Sourcegraph, Cursor.
> Si sos Claude / Codex / Gemini / OpenClaw / o cualquier otro agente CLI, **leé esto primero**.

---

## Qué es esto

Este repositorio contiene el **Mothership Method**: un sistema de memoria persistente para agentes IA que evita el problema "mi IA olvida todo entre sesiones". Es markdown + bash + hooks. Sin SaaS. Sin lock-in. Cualquier agente lo puede usar.

## Tu trabajo si el usuario te pidió "instalá esto"

Seguí los pasos en `BOOTSTRAP_FOR_AGENT.md` exactamente. Está escrito para vos, no para humanos.

## Tu trabajo si ya está instalado

1. Antes de cualquier respuesta sustantiva, leé:
   - `<workspace>/AGENTS.md` (las reglas de este workspace, ya instaladas)
   - `<workspace>/CROSS_SYNC.md` (últimas 15 entradas operacionales)
2. Si el usuario menciona un proyecto, resolverlo a slug vía `project-resolve` y leer `projects/<slug>/FAST_RESUME.md` (≤3KB).
3. Después de cualquier cambio operativo, ejecutar el Doc Checklist de 9 pasos (ver `<workspace>/AGENTS.md`).
4. Nunca borrar — siempre archivar siguiendo `ARCHIVE_POLICY.md`.

## Compatibilidad multi-agente

Este sistema fue diseñado para que **3+ agentes** (Claude Code + Codex + Gemini CLI + OpenClaw) compartan el mismo workspace y coordinen vía `CROSS_SYNC.md`. Si trabajás en un proyecto donde otro agente ya hizo cambios, los vas a ver en `CROSS_SYNC.md` con timestamp + actor.

## Identificate al cambiar

Cuando appendees a `CROSS_SYNC.md`, identificate por nombre exacto:
- `Claude Code (claude-opus-4-7)` o el modelo que seas
- `Codex CLI`
- `Gemini CLI`
- `OpenClaw`
- O el nombre canónico de tu plataforma

Esto permite que otros agentes te identifiquen si tu cambio rompe algo.

## Más información

- `BOOTSTRAP_FOR_AGENT.md` — instalación auto-guiada (para vos)
- `INSTALL_VIA_AGENT.md` — prompt copy-paste (para el humano)
- `README.md` — descripción para humanos
- `METHOD.md` — guía completa del método
- `CHEATSHEET.md` — comandos esenciales

---

**Si dudás de qué hacer, leé `BOOTSTRAP_FOR_AGENT.md` y seguí esos pasos. Si está incompleto o ambiguo, preguntá al usuario antes de actuar.**
