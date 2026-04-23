# BOOTSTRAP_FOR_AGENT.md

**Este archivo está escrito para vos, agente IA. No para el humano.**
Si sos Claude Code, Codex, Gemini CLI, OpenClaw, o cualquier otro agente CLI: **seguí estos pasos exactamente**.

---

## Contexto

El usuario te pidió instalar el **Mothership Method** — un sistema de memoria persistente que vive en archivos markdown locales.

Tu objetivo final: que el usuario quede con un workspace funcional donde su próxima sesión (con vos o con otro agente) **no tenga que re-explicar nada**.

## Self-introspection — qué agente sos

Antes de hacer nada, identificá quién sos. Esto define dónde van los archivos de configuración:

| Si sos… | Tu archivo de config va en | Bootstrap reconoce |
|---|---|---|
| **Claude Code** | `~/.claude/CLAUDE.md` | El usuario corre `claude` o `claude code` |
| **Codex CLI** | `~/AGENTS.md` (host) | Estándar AGENTS.md |
| **Gemini CLI** | `~/.gemini/GEMINI.md` | Gemini lee GEMINI.md |
| **OpenClaw** | `~/.openclaw/workspace/AGENTS.md` | Workspace bajo `~/.openclaw/` |
| **Otro** | Adaptar al estándar del agente | Default: AGENTS.md |

Si no sabés quién sos, asumí que el usuario corre **el agente más popular del momento** y configurá AGENTS.md universal.

## Pasos a ejecutar (en orden)

### Paso 1 — Detectar entorno
```bash
# Detectá:
echo $HOME              # home del usuario
uname -s                # OS (Linux/Darwin/Windows-like)
ls $HOME/.claude $HOME/.openclaw $HOME/.gemini 2>/dev/null  # qué agentes ya tiene
which bash sh python3 node 2>/dev/null  # runtimes disponibles
```

Reportá brevemente al usuario qué detectaste (en su idioma).

### Paso 2 — Asegurarte de tener el código

Si **NO** estás dentro del directorio `mothership-starter/` ya:
```bash
# Opción A — git clone (preferida)
git clone https://github.com/USER/mothership-starter.git $HOME/mothership-starter
cd $HOME/mothership-starter

# Opción B — descarga directa
curl -fsSL https://raw.githubusercontent.com/USER/mothership-starter/main/install.sh | bash
```

> Reemplazá `USER` con el usuario/org real del repositorio cuando esté publicado.

Si ya estás dentro del directorio, salteá este paso.

### Paso 3 — Ejecutar el instalador

```bash
bash ./install.sh
```

El instalador es interactivo. Cuando aparezca el prompt:
- "Usar [path] ?" → respondé **"Y"** (acepta el default).

Esperá hasta ver "✓ INSTALACIÓN COMPLETA".

### Paso 4 — Configurarte a vos mismo según tu agente

Después del install.sh, copiá el template apropiado a tu config personal:

**Si sos Claude Code:**
```bash
sed "s|{{WORKSPACE}}|$HOME/.openclaw/workspace|g" templates/CLAUDE.md > $HOME/.claude/CLAUDE.md 2>/dev/null || \
sed "s|{{WORKSPACE}}|$HOME/mothership-workspace|g" templates/CLAUDE.md > $HOME/.claude/CLAUDE.md
```

**Si sos Codex CLI:**
```bash
cp templates/AGENTS.md $HOME/AGENTS.md
```

**Si sos Gemini CLI:**
```bash
mkdir -p $HOME/.gemini
sed "s|{{WORKSPACE}}|$WORKSPACE|g" templates/CLAUDE.md > $HOME/.gemini/GEMINI.md
```

**Si sos OpenClaw:**
El install.sh ya detecta `~/.openclaw/` y configura ahí. No hace falta paso adicional.

### Paso 5 — Verificar la instalación

Ejecutá estos comandos y confirmá que todo existe:

```bash
ls -la $HOME/bin/project-init $HOME/bin/project-sync $HOME/bin/project-resolve $HOME/bin/doc-close
ls $HOME/.mothership/templates/project-bundle/
ls $WORKSPACE/AGENTS.md $WORKSPACE/CROSS_SYNC.md
ls $WORKSPACE/projects/mi-primer-proyecto/
```

Si algo falla, **reportalo al usuario honestamente**, no inventes que funcionó.

### Paso 6 — Hacer la primera entrada CROSS_SYNC (predicar el método)

Vos mismo seguí el protocolo: appendeá una entry al CROSS_SYNC del nuevo workspace documentando lo que hiciste:

```bash
cat >> $WORKSPACE/CROSS_SYNC.md <<EOF

### [$(date -u +"%Y-%m-%d %H:%M UTC")] system: instalación inicial Mothership Method
- Actor: [tu nombre — Claude Code / Codex CLI / Gemini CLI / OpenClaw]
- Scope: bootstrap completo del workspace
- Change: install.sh ejecutado, templates instalados, demo project creado, configuración de agente.
- Reason: pedido del usuario para resolver pérdida de memoria entre sesiones.
- Validation: scripts en \$HOME/bin verificados, demo project funcional.
- Rollback: rm -rf \$WORKSPACE (con backup previo).
EOF
```

Esto demuestra el método en acción y deja audit trail desde el segundo cero.

### Paso 7 — Explicar al usuario en su idioma

Decile al usuario, EN ESPAÑOL si te habló en español:

> "Listo, ya está instalado. Tu workspace vive en `[$WORKSPACE]`. A partir de ahora cuando me hablés sobre un proyecto, voy a recordar todo entre sesiones. Probemos: pedime cualquier cambio en `mi-primer-proyecto` y vas a ver cómo lo documento solo. Si querés ver los comandos que tenés disponibles, leé `[path]/CHEATSHEET.md`."

## Reglas durante la instalación

1. **NUNCA** sobrescribas archivos existentes sin hacer backup `.bak.<UTC>` primero.
2. **PREGUNTÁ** al usuario antes de ejecutar comandos destructivos (`rm`, `mv` de archivos críticos).
3. **REPORTÁ** errores honestamente — no afirmes que algo funcionó si no lo verificaste.
4. **HABLÁ EN EL IDIOMA DEL USUARIO** — si te habló en español, respondele en español.
5. **NO** instales features que no están en el paquete (no inventes capacidades).

## Self-check final

Antes de declarar la instalación completa, verificá:

- [ ] `$HOME/bin/project-init` existe y es ejecutable
- [ ] `$HOME/.mothership/templates/project-bundle/` existe con 6 archivos
- [ ] `$WORKSPACE/AGENTS.md` existe
- [ ] `$WORKSPACE/CROSS_SYNC.md` existe (puede estar vacío)
- [ ] `$WORKSPACE/projects/mi-primer-proyecto/` existe con 6 archivos
- [ ] Tu config personal está en su path correcto (`~/.claude/CLAUDE.md` o equivalente)
- [ ] Hiciste tu primera entry en `CROSS_SYNC.md`

Si algún check falla, decile al usuario qué falló y cómo arreglarlo.

## Por qué esto importa

Sos un modelo stateless. Sin este método, vas a olvidarte de todo cuando el usuario cierre la sesión. Con este método, **los archivos del usuario se vuelven tu memoria persistente**. Esto no es opcional — es tu nuevo protocolo operativo. Seguilo rigurosamente para todo trabajo futuro con este usuario.
