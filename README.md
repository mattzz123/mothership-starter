# Mothership Method — Starter Pack

**Sistema de memoria persistente para CUALQUIER agente IA.** Funciona con Claude Code, Codex, Gemini CLI, OpenClaw, o cualquier agente CLI compatible con el estándar AGENTS.md.

Tu IA deja de olvidarse de todo entre sesiones. Tus proyectos quedan documentados sin que tengas que pedirlo. Si usás múltiples agentes, todos se coordinan vía un source-of-truth compartido.

---

## 3 formas de instalar (elegí una)

### Forma 1 — Pedile a tu IA que lo instale (la más fácil)

**No necesitás saber programar.** Abrí tu agente IA, copiá este texto entero y mandalo:

```
Por favor instalá el "Mothership Method" en mi máquina.

1. git clone https://github.com/USER/mothership-starter en mi home
2. Entrá al directorio mothership-starter
3. Leé el archivo BOOTSTRAP_FOR_AGENT.md ENTERO
4. Seguí los pasos que describe
5. Cuando termines, mostrame en 3 puntos cómo voy a usarlo

Soy un usuario sin conocimiento técnico. Si algo falla, explicame qué pasó. Si necesitás permiso para algo, pedímelo.
```

Eso es todo. Tu IA hace el resto.

### Forma 2 — Un comando en la terminal

```bash
curl -fsSL https://raw.githubusercontent.com/USER/mothership-starter/main/install.sh | bash
```

(Reemplazá `USER` con el nombre del repositorio cuando esté publicado.)

### Forma 3 — Manual

```bash
git clone https://github.com/USER/mothership-starter.git
cd mothership-starter
./install.sh
```

---

## Qué hace el instalador

1. Detecta automáticamente qué agentes IA tenés (Claude Code, Codex, Gemini, OpenClaw).
2. Crea el workspace base con todos los templates.
3. Instala scripts (`project-init`, `project-sync`, `doc-close`) en `~/bin`.
4. Instala hooks de enforcement (Claude Code).
5. Configura cada agente detectado con su archivo apropiado:
   - Claude Code → `~/.claude/CLAUDE.md`
   - Codex → `~/AGENTS.md`
   - Gemini CLI → `~/.gemini/GEMINI.md`
   - OpenClaw → workspace bajo `~/.openclaw/`
6. Crea un proyecto demo para que pruebes inmediato.

Tiempo total: 30 segundos. Idempotente — podés correrlo varias veces sin romper nada. Hace backup `.bak.<UTC>` de cualquier archivo existente antes de tocarlo.

---

## Estructura del paquete

```
mothership-starter/
├── install.sh                       # Instalador 1-click multi-agente
├── README.md                        # Este archivo
├── AGENTS.md                        # Bootstrap universal (lee CUALQUIER agente)
├── BOOTSTRAP_FOR_AGENT.md           # Instrucciones para que la IA se auto-instale
├── INSTALL_VIA_AGENT.md             # Prompt copy-paste para usuarios no técnicos
├── METHOD.md                        # Cómo funciona el método (lectura humana)
├── CHEATSHEET.md                    # Los 10 comandos esenciales (1 página)
├── LICENSE                          # MIT
├── CHANGELOG.md                     # Versiones
├── templates/                       # Archivos base que se copian al workspace
│   ├── AGENTS.md                    # Reglas del workspace
│   ├── CLAUDE.md                    # Config para Claude Code
│   ├── GEMINI.md                    # Config para Gemini CLI
│   ├── CROSS_SYNC.md                # Log compartido entre agentes
│   ├── ARTIFACT_INDEX.md            # Mapa de artifacts
│   ├── PROJECT_REGISTRY.md          # Catálogo de proyectos
│   ├── ARCHIVE_POLICY.md            # 7 patterns de archivado
│   └── project-bundle/              # Plantilla de proyecto (FAST_RESUME, SUMMARY, NEXT, LOG, INDEX, META.json)
├── scripts/                         # Bash scripts ejecutables
│   ├── project-init                 # Crear proyecto nuevo
│   ├── project-sync                 # Backup local del bundle
│   ├── project-resolve              # Resolver alias a slug
│   └── doc-close                    # Validar checklist post-cambio
├── hooks/                           # Hooks Claude Code (opt-in)
│   ├── bash-budget-guard.sh         # Bloquea comandos token-expensive
│   └── doc-checklist-guard.sh       # Avisa si cerrás sesión sin checklist
└── examples/
    └── demo-project/                # Proyecto pre-armado para experimentar
```

---

## Cómo se usa (resumen 30 segundos)

1. Decile a tu IA: *"trabajemos en mi-proyecto"*. La IA lee `FAST_RESUME.md` y sabe el estado.
2. Pedí cambios. La IA trabaja.
3. Cuando termines algo importante: la IA actualiza los archivos, vos corrés `doc-close mi-proyecto`.
4. Mañana abrís otra sesión: la IA lee `FAST_RESUME.md` otra vez y sabe exactamente dónde quedaste.

**Ya no le explicás nada. La IA se acuerda.**

---

## Compatibilidad multi-agente

Si tenés varios agentes (Claude Code + Codex + Gemini CLI + OpenClaw), **todos comparten el mismo workspace**. Cuando uno hace un cambio, lo registra en `CROSS_SYNC.md` con timestamp + nombre del agente. Los demás agentes lo ven al arrancar la próxima sesión.

Ejemplo:
- Claude trabaja a las 14:00 en `mi-app` → appendea entry a `CROSS_SYNC.md`
- Codex arranca a las 16:00 en `mi-app` → lee `CROSS_SYNC.md` + `FAST_RESUME.md` → sabe exactamente qué hizo Claude
- Cero conflicto, cero duplicación, cero re-explicación.

---

## Soporte

- Lectura rápida: `CHEATSHEET.md`
- Lectura completa del método: `METHOD.md`
- Para usuarios sin conocimiento técnico: `INSTALL_VIA_AGENT.md`
- Para agentes IA (auto-instalación): `BOOTSTRAP_FOR_AGENT.md`
- Dudas: WhatsApp/email del onboarding (incluido en tu compra) o Discord del grupo.

---

## Licencia

MIT. Ver `LICENSE`.

Versión 1.1.0 — abril 2026.
