# BOOTSTRAP_FOR_AGENT.md (v1.1.1)

**Este archivo está escrito para vos, agente IA. No para el humano.**
Si sos Claude Code, Codex, Gemini CLI, OpenClaw, o cualquier otro agente: **seguí estos pasos exactamente**.

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

Cuando aparezca el prompt "Usar [path] ?" → respondé **Y** (acepta el default).
Esperá hasta ver "✓ INSTALACIÓN COMPLETA".

### Paso 4 — Configurar tu propio archivo de identidad agente

Después del install.sh:

- **Si sos Claude Code:** ya quedó instalado `~/.claude/CLAUDE.md`.
- **Si sos Codex CLI:** ya quedó instalado `~/AGENTS.md`.
- **Si sos Gemini CLI:** ya quedó instalado `~/.gemini/GEMINI.md`.
- **Si sos OpenClaw:** el install.sh detectó `~/.openclaw/` y configuró ahí.

### Paso 5 — Verificar la instalación

```bash
ls -la $HOME/bin/project-init $HOME/bin/project-sync $HOME/bin/project-resolve $HOME/bin/doc-close
ls $HOME/.mothership/templates/project-bundle/
ls $WORKSPACE/AGENTS.md $WORKSPACE/CROSS_SYNC.md $WORKSPACE/PROJECT_REGISTRY.md
```

Si algo falla, **reportalo al usuario honestamente**, no inventes que funcionó.

### Paso 6 — Documentar la instalación en CROSS_SYNC.md (OBLIGATORIO)

**ESTE PASO NO ES OPCIONAL.** Mostrá disciplina del método predicando con el ejemplo:

```bash
cat >> $WORKSPACE/CROSS_SYNC.md <<EOF

### [$(date -u +"%Y-%m-%d %H:%M UTC")] system: instalación inicial Mothership Method v1.1.1
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

> "Listo, instalé Mothership Method v1.1.1 en tu workspace `[path]`. Ahora cuando me hablés sobre un proyecto voy a recordar todo entre sesiones. Probemos: pedime crear tu primer proyecto real con: *'Creá un proyecto X con scope tal y tal'*. Cualquier comando esencial está en CHEATSHEET.md."

---

## REGLAS DE ORO durante operación post-instalación

### Regla #1 — Cuando el usuario te pida CREAR un proyecto

**NUNCA** ejecutes `project-init` sin `--scope` y `--alias`.

Workflow obligatorio:
1. Si el usuario te dio scope detallado en su mensaje → usalo directamente.
2. Si NO te dio scope → preguntale ANTES de crear:
   > "Para crear el proyecto necesito saber: (a) ¿cuál es el objetivo/scope? (b) ¿qué aliases naturales le pondrías para encontrarlo después? (c) ¿título humano (opcional)?"
3. Una vez que tengas scope + aliases, ejecutá:
   ```bash
   project-init <slug> --scope "..." --alias "..." --alias "..." --title "..."
   ```
4. El script hace TODO automáticamente: completa SUMMARY/FAST_RESUME/NEXT con info real, agrega entry a PROJECT_REGISTRY.md, appendea CROSS_SYNC.md, corre project-sync.
5. Reportá al usuario el resultado.

**NUNCA** dejes archivos del bundle en estado placeholder. Si por algún motivo creaste un proyecto sin scope (ej. el usuario solo dijo "creá X"), inmediatamente preguntale por el scope para completarlo.

### Regla #2 — Cuando el usuario te pida BORRAR algo

**NUNCA usés `rm`.** El verbo operativo es **archivar**, no borrar.

Workflow:
1. Pedí confirmación explícita.
2. Al confirmar, ejecutá:
   ```bash
   mv projects/<slug> projects/<slug>_archive_$(date -u +%Y%m%dT%H%MZ)/
   ```
3. Reportá: "Archivé el proyecto en `projects/<slug>_archive_<UTC>/`. Si querés recuperarlo, está intacto ahí."

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
- [ ] `$HOME/.mothership/templates/project-bundle/` existe con 6 archivos
- [ ] `$WORKSPACE/AGENTS.md` existe (con backup `.bak.<UTC>` del original si había)
- [ ] `$WORKSPACE/CROSS_SYNC.md` existe + **vos appendeaste tu entry** (paso 6)
- [ ] `$WORKSPACE/projects/mi-primer-proyecto/` existe con 6 archivos
- [ ] Tu config personal está en su path correcto

Si algún check falla, decile al usuario qué falló y cómo arreglarlo.

---

## Por qué esto importa

Sos un modelo stateless. Sin este método, vas a olvidarte de todo cuando el usuario cierre la sesión. Con este método, **los archivos del usuario se vuelven tu memoria persistente**.

Esto NO es opcional — es tu nuevo protocolo operativo. Seguilo rigurosamente.
