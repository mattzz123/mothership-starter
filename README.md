# Mothership Method — Starter Pack

**Sistema de memoria persistente para CUALQUIER agente IA.** Funciona con Claude Code, Codex, Gemini CLI, OpenClaw, o cualquier agente CLI compatible con el estándar AGENTS.md.

Tu IA deja de olvidarse de todo entre sesiones. Tus proyectos quedan documentados sin que tengas que pedirlo. Si usás múltiples agentes, todos se coordinan vía un source-of-truth compartido.

---

## Dos niveles — empezá por el primero

**Nivel 1 — en una carpeta.** Nueve archivos de texto adentro de una carpeta tuya. No instala programas, no copia ejecutables, no toca la configuración de tu asistente, no se conecta a ningún lado. Para desinstalar, borrás la carpeta. **Es lo que necesita la mayoría, y funciona por sí solo.**

👉 **[INSTALAR_CARPETA.md](INSTALAR_CARPETA.md)** — si empezás de cero.
👉 **[ADOPTAR_LO_QUE_YA_TENGO.md](ADOPTAR_LO_QUE_YA_TENGO.md)** — si ya venís trabajando con tu asistente y tenés notas de meses anteriores. Ordena lo que ya escribiste; no borra ni mueve nada.

Ninguno de los dos requiere saber programar.

**Nivel 2 — con automatizaciones.** Comandos (`project-init`, `doc-close`) y verificaciones que corren solas al cerrar cada sesión. Instala archivos ejecutables y modifica la configuración de tu asistente de forma permanente, para todas tus conversaciones. Es una decisión aparte: tomala entendiendo qué hace cada pieza. Es lo que se describe abajo.

---

## Nivel 2 — 3 formas de instalar (elegí una)

### Forma 1 — Pedile a tu IA que lo instale (la más fácil)

**No necesitás saber programar.** Está todo en **[MASTERPROMPT.md](MASTERPROMPT.md)**: abrí tu agente IA, copiá el mensaje que está ahí y mandalo. La IA hace el resto sola.

Versión corta del mensaje:

```
Quiero que instales en mi computadora el "Mothership Method": un sistema para que
no te olvides de lo que hablamos entre una conversación y la otra.

Instalalo vos entero. Yo no sé programar, así que no me pidas que edite archivos,
que abra una terminal, ni que copie y pegue configuraciones.

Pasos:
1. git clone https://github.com/mattzz123/mothership-starter.git "$HOME/mothership-starter"
2. Entrá a esa carpeta y leé BOOTSTRAP_FOR_AGENT.md COMPLETO
3. Seguí todos los pasos que indica, del 1 al 8, sin saltearte ninguno
4. Cuando termines, decime en 3 puntos cómo lo uso y cuál es la carpeta
   que tengo que elegir siempre al abrir una conversación

Si algo falla, explicame con tus palabras qué pasó. Si necesitás mi permiso, pedímelo.
```

> **Windows:** la pestaña **Code** de Claude Desktop necesita [Git for Windows](https://git-scm.com/downloads/win) instalado la primera vez (reiniciá la app después). Con eso alcanza — el método corre nativo sobre Git Bash, sin WSL ni PowerShell.

### Forma 2 — Un comando en la terminal

```bash
curl -fsSL https://raw.githubusercontent.com/mattzz123/mothership-starter/main/install.sh | bash
```

### Forma 3 — Manual

```bash
git clone https://github.com/mattzz123/mothership-starter.git
cd mothership-starter
./install.sh
```

---

## Qué hace el instalador

1. Detecta automáticamente qué agentes IA tenés (Claude Code, Codex, Gemini, OpenClaw).
2. Crea el workspace base con todos los templates.
3. Instala scripts (`project-init`, `project-sync`, `doc-close`) en `~/bin`.
4. Instala **y activa** los hooks de enforcement en `~/.claude/settings.json` (respetando la config que ya tengas).
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

- **Empezar de cero (no técnico): `MASTERPROMPT.md`**
- Lectura rápida: `CHEATSHEET.md`
- Lectura completa del método: `METHOD.md`
- Otras formas de instalar: `INSTALL_VIA_AGENT.md`
- Para agentes IA (auto-instalación): `BOOTSTRAP_FOR_AGENT.md`

Después de instalar, los docs quedan copiados en `~/.mothership/docs/`.

---

## Licencia

MIT. Ver `LICENSE`.

Versión 1.2.0 — agosto 2026.
