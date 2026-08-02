# BOOTSTRAP_FOR_AGENT.md (v1.2.0)

**Este archivo está escrito para vos, agente IA. No para el humano.**
Si sos Claude Code, Codex, Gemini CLI, OpenClaw, o cualquier otro agente: **seguí estos pasos exactamente**.

> **Asumí que la persona que te está hablando no es técnica.** No le pidas que edite
> archivos de configuración, que abra una terminal, ni que copie y pegue JSON. Todo lo
> que haya que hacer, lo hacés vos. Si algo falla, explicáselo en palabras simples y
> decile qué se puede hacer — nunca lo dejes con un error crudo en pantalla.

---

## Contexto

El usuario te pidió instalar el **Mothership Method** — un sistema de memoria persistente que vive en archivos markdown locales.

Tu objetivo final: que el usuario quede con un workspace funcional donde su próxima sesión (con vos o con otro agente) **no tenga que re-explicar nada**.

---

## Pasos a ejecutar (en orden, sin omitir ninguno)

### Paso 1 — Detectar entorno

```bash
echo $HOME
uname -s
ls $HOME/.claude $HOME/.openclaw $HOME/.gemini 2>/dev/null
which bash sh python3 node 2>/dev/null
```

Reportá brevemente al usuario qué detectaste, en su idioma.

### Paso 2 — Asegurarte de tener el código

Si NO estás dentro del directorio `mothership-starter/`:

```bash
# Opción A — git clone
git clone https://github.com/mattzz123/mothership-starter.git $HOME/mothership-starter
cd $HOME/mothership-starter

# Opción B — descarga directa (si git no está disponible)
curl -fsSL https://raw.githubusercontent.com/mattzz123/mothership-starter/main/install.sh | bash
```

### Paso 3 — Ejecutar el instalador

```bash
bash ./install.sh
```

**El instalador v1.2.0 es NO-INTERACTIVO.** No hace preguntas cuando lo corre un agente: detecta que no hay terminal y usa el workspace default (`$HOME/mothership-workspace`). No esperes ningún prompt y **no le preguntes nada al usuario**.

Si querés forzar otra ubicación:

```bash
bash ./install.sh --workspace "$HOME/mi-carpeta"
```

El instalador hace, en una sola pasada:
1. Crea el workspace con sus archivos base
2. Instala los scripts en `~/bin` y los agrega al PATH (`~/.bashrc`)
3. Instala los hooks Y **los activa** en `~/.claude/settings.json` (conservando la config previa)
4. Instala el archivo de identidad de cada agente detectado
5. Crea un proyecto demo
6. Copia los docs a `~/.mothership/docs/` y **archiva** el fuente en `~/.mothership/source-archive/`

**Nada se borra en ningún paso.** Si algo falla, el original queda intacto.

Esperá hasta ver `✓ INSTALACIÓN COMPLETA`. Si el script termina con código distinto de 0, **reportá el error tal cual al usuario** y no sigas.

### Paso 3.5 — Windows (leer solo si estás en Windows)

Comprobalo con `uname -s`: si dice `MINGW*` o `MSYS*`, estás en Git Bash sobre Windows.

- **Git Bash es obligatorio y ya está instalado** si Claude Desktop abrió la pestaña Code. Los scripts y hooks del método corren ahí de forma nativa: no hace falta WSL ni PowerShell.
- **No conviertas los scripts a CRLF.** El repo trae `.gitattributes` que fuerza LF. Si aun así ves el error `$'\r': command not found`, corregilo con `sed -i 's/\r$//' <archivo>`.
- **La carpeta de descarga no se puede borrar mientras el script corre** (Windows bloquea el archivo en ejecución). Por eso el archivado se hace al final y desde afuera (Paso 8).
- El home en Git Bash es `/c/Users/<nombre>`. Usá siempre `$HOME`, nunca rutas con `C:\`.

### Paso 3.6 — Verificar que los hooks quedaron activos

```bash
cat "$HOME/.claude/settings.json"
```

Tenés que ver dos entradas bajo `hooks`: una en `PreToolUse` (bash-budget-guard) y otra en `Stop` (doc-checklist-guard).

**Si en cambio existe `~/.claude/mothership-hooks.json`**, el instalador no pudo hacer el merge automático (no había python ni node). En ese caso **el merge lo hacés vos ahora**: leé ese archivo y `~/.claude/settings.json`, combinálos conservando **toda** la configuración existente del usuario, y escribí el resultado. Es tu tarea, no la del usuario. Después verificá que el JSON quedó válido.

### Paso 4 — Configurar tu propio archivo de identidad agente

Después del install.sh:

- **Si sos Claude Code:** ya quedó instalado `~/.claude/CLAUDE.md`.
- **Si sos Codex CLI:** ya quedó instalado `~/AGENTS.md`.
- **Si sos Gemini CLI:** ya quedó instalado `~/.gemini/GEMINI.md`.
- **Si sos OpenClaw:** el install.sh detectó `~/.openclaw/` y configuró ahí.

### Paso 5 — Verificar la instalación

```bash
WORKSPACE="$HOME/mothership-workspace"   # o el path que hayas pasado con --workspace
ls -la "$HOME"/bin/project-init "$HOME"/bin/project-sync "$HOME"/bin/project-resolve "$HOME"/bin/doc-close
ls "$HOME"/.mothership/templates/project-bundle/
ls "$WORKSPACE"/AGENTS.md "$WORKSPACE"/CROSS_SYNC.md "$WORKSPACE"/PROJECT_REGISTRY.md
ls "$WORKSPACE"/projects/mi-primer-proyecto/
```

Y probá que los scripts sean alcanzables por nombre:

```bash
export PATH="$HOME/bin:$PATH"
doc-close mi-primer-proyecto
```

Si algo falla, **reportalo al usuario honestamente**, no inventes que funcionó.

### Paso 6 — Documentar la instalación en CROSS_SYNC.md (OBLIGATORIO)

**ESTE PASO NO ES OPCIONAL.** Mostrá disciplina del método predicando con el ejemplo:

```bash
cat >> $WORKSPACE/CROSS_SYNC.md <<EOF

### [$(date -u +"%Y-%m-%d %H:%M UTC")] system: instalación inicial Mothership Method v1.2.0
- Actor: [tu nombre — ej. Jarvis 2.0 (OpenClaw + Codex)]
- Scope: bootstrap completo del workspace
- Change: install.sh ejecutado, scripts en \$HOME/bin, templates en \$HOME/.mothership/, AGENTS.md actualizado.
- Reason: pedido del usuario para resolver pérdida de memoria entre sesiones.
- Validation: scripts ejecutables, demo project verificado, doc-close OK.
- Rollback: rm -rf \$WORKSPACE; restore \$WORKSPACE/AGENTS.md.bak.<UTC>.
EOF
```

### Paso 7 — Explicar al usuario en su idioma

Decile al usuario en su idioma (español si te habló en español):

> "Listo. Ahora tenés memoria: todo lo que trabajemos queda guardado en la carpeta `[path]` de tu computadora, y la próxima vez que abramos una conversación yo la leo sola y sé dónde quedamos. No tenés que volver a explicarme nada.
>
> Para que funcione, hay una sola cosa que tenés que hacer siempre: **abrí la conversación eligiendo esa misma carpeta**.
>
> Probemos ahora. Decime en qué querés que trabajemos — un cliente, un tema, un proyecto — y lo creo."

Adaptalo al idioma y al nivel del usuario. Si no es técnico: **nada de rutas, flags ni nombres de archivo** en la explicación. Habla de "tu carpeta" y "tu memoria".

### Paso 8 — Archivar la carpeta de descarga (último paso)

El instalador ya dejó una copia íntegra del fuente en `~/.mothership/source-archive/<fecha>/`. Ahora dejá limpio el home del usuario moviendo la carpeta que se descargó — **no la borres**, movela:

```bash
mkdir -p "$HOME/.mothership/downloads-archive"
mv "$HOME/mothership-starter" "$HOME/.mothership/downloads-archive/mothership-starter-$(date -u +%Y%m%dT%H%MZ)"
```

Esto tiene que pasar **después** de que `install.sh` haya terminado: en Windows el archivo en ejecución está bloqueado por el sistema operativo y el movimiento falla mientras el script corre.

Verificá que salió bien:

```bash
ls "$HOME/.mothership/downloads-archive/"
```

Si falla, **decíselo al usuario** y dejá la carpeta donde está. No es grave: la instalación ya está completa y funcionando.

---

## REGLAS DE ORO durante operación post-instalación

### Regla #1 — Cuando el usuario te pida CREAR un proyecto

**NUNCA** ejecutes `project-init` sin `--scope` y `--alias`.

El script `project-init` v1.1.2+ FALLA si no recibe `--scope`. Eso es intencional.

Workflow obligatorio:
1. Si el usuario te dio scope detallado en su mensaje → usalo directamente.
2. Si NO te dio scope → preguntale ANTES de intentar crear:
   > "Para crear el proyecto necesito saber: (a) ¿cuál es el objetivo/scope? (b) ¿qué aliases naturales le pondrías para encontrarlo después? (c) ¿título humano (opcional)?"
3. Una vez que tengas scope + aliases, ejecutá:
   ```bash
   project-init <slug> --scope "..." --alias "..." --alias "..." --title "..."
   ```
4. El script hace TODO automáticamente: completa SUMMARY/FAST_RESUME/NEXT con info real, agrega entry a PROJECT_REGISTRY.md, appendea CROSS_SYNC.md, corre project-sync.
5. Reportá al usuario el resultado.

**NUNCA intentes** ejecutar `project-init <slug>` sin `--scope` esperando que funcione — el script va a abortar con error claro.

### Regla #2 — Cuando el usuario te pida ARCHIVAR/BORRAR algo

**NUNCA usés `rm`.** El verbo operativo es **archivar**, no borrar.

**Regla léxica:** en tus respuestas al usuario, NO uses palabras como *"borrar", "eliminar", "delete", "remove"*. Usá *"archivar", "mover a archive", "deshabilitar"*.

Workflow:
1. Pedí confirmación explícita usando lenguaje correcto:
   > *"Voy a archivarlo en `projects/<slug>_archive_<UTC>/`. Sigue siendo recuperable. ¿Confirmás?"*
2. Al confirmar, ejecutá:
   ```bash
   mv projects/<slug> projects/<slug>_archive_$(date -u +%Y%m%dT%H%MZ)/
   ```
3. Reportá: *"Archivé el proyecto en `projects/<slug>_archive_<UTC>/`. Si querés recuperarlo, está intacto ahí."*

### Regla #3 — Cuando hagas cambios operativos

Después de modificar archivos del bundle (SUMMARY, FAST_RESUME, etc.):
1. Appendear entry a `LOG.md` del proyecto con timestamp + Contexto/Change/Reason/Validation/Rollback/Follow-up.
2. Si el cambio es estructural (decisión de arquitectura, cambio de stack), appendear también a `CROSS_SYNC.md`.
3. Ejecutar `doc-close <slug>` para validar.
4. Mostrarle al usuario el resultado del doc-close.

### Regla #4 — Backups antes de editar archivos del workspace

Antes de editar `AGENTS.md`, `CROSS_SYNC.md`, `PROJECT_REGISTRY.md`, `ARTIFACT_INDEX.md`, `ARCHIVE_POLICY.md`:
```bash
cp <archivo> <archivo>.bak.$(date -u +%Y%m%dT%H%MZ)
```

### Regla #5 — Honestidad operativa

- **NUNCA** afirmes que ejecutaste algo si no lo verificaste.
- Si un comando falla, **reportalo** al usuario en lugar de pretender éxito.
- Si NO sabés cómo hacer algo, **preguntá** en lugar de inventar.

---

## Self-check final

Antes de declarar la instalación completa, verificá:

- [ ] `$HOME/bin/project-init` existe y es ejecutable
- [ ] `$HOME/bin` quedó en el PATH (`grep 'HOME/bin' ~/.bashrc`)
- [ ] `$HOME/.mothership/templates/project-bundle/` existe con 6 archivos
- [ ] `$HOME/.claude/settings.json` tiene los 2 hooks activos y es **JSON válido**
- [ ] `$HOME/.mothership/docs/` tiene CHEATSHEET.md y METHOD.md
- [ ] `$WORKSPACE/AGENTS.md` existe (con backup `.bak.<UTC>` del original si había)
- [ ] `$WORKSPACE/CROSS_SYNC.md` existe + **vos appendeaste tu entry** (paso 6)
- [ ] `$WORKSPACE/projects/mi-primer-proyecto/` existe con 6 archivos
- [ ] Tu config personal está en su path correcto
- [ ] La carpeta de descarga quedó archivada (paso 8)

Si algún check falla, decile al usuario qué falló y cómo arreglarlo.

---

## Por qué esto importa

Sos un modelo stateless. Sin este método, vas a olvidarte de todo cuando el usuario cierre la sesión. Con este método, **los archivos del usuario se vuelven tu memoria persistente**.

Esto NO es opcional — es tu nuevo protocolo operativo. Seguilo rigurosamente.
