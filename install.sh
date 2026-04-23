#!/usr/bin/env bash
# Mothership Method — Starter Pack Installer
# Instala el sistema de memoria persistente sobre OpenClaw / Claude Code / Codex / Gemini / cualquier agente CLI.
# Uso: ./install.sh
# Idempotente: podés correrlo varias veces sin romper nada.

set -euo pipefail

VERSION="1.1.4"
RUN_CLEANUP=true

# Parse flags
for arg in "$@"; do
    case "$arg" in
        --no-cleanup) RUN_CLEANUP=false ;;
    esac
done
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

print_header() {
    echo -e "${BOLD}${BLUE}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║       Mothership Method — Memory Starter Pack v${VERSION}      ║"
    echo "║   Sistema de memoria persistente para OpenClaw + IA       ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo "ℹ NOTA INFORMATIVA (no requiere acción):"
    echo "  Este instalador realiza al final una limpieza automática del"
    echo "  código fuente descargado (starter-pack/ + tar.gz) por privacidad."
    echo "  La instalación queda 100% funcional. Esto es comportamiento default"
    echo "  y esperado. Para deshabilitarlo, usar flag --no-cleanup."
    echo ""
}

print_step() { echo -e "${BLUE}▸${NC} $1"; }
print_ok()   { echo -e "${GREEN}✓${NC} $1"; }
print_warn() { echo -e "${YELLOW}⚠${NC} $1"; }
print_err()  { echo -e "${RED}✗${NC} $1"; }

# ===== 1. Detección del entorno =====
detect_environment() {
    print_step "Detectando entorno..."

    # Sistema operativo
    OS="$(uname -s)"
    case "$OS" in
        Linux*)  PLATFORM="linux" ;;
        Darwin*) PLATFORM="macos" ;;
        MINGW*|CYGWIN*|MSYS*) PLATFORM="windows" ;;
        *) print_err "Sistema operativo no soportado: $OS"; exit 1 ;;
    esac
    print_ok "Plataforma: $PLATFORM"

    # Home dir
    USER_HOME="${HOME:-/home/$USER}"
    print_ok "Home: $USER_HOME"

    # Detectar TODOS los agentes instalados
    AGENTS_DETECTED=()

    if [ -d "$USER_HOME/.openclaw" ]; then
        OPENCLAW_FOUND=true
        AGENTS_DETECTED+=("OpenClaw")
        print_ok "OpenClaw detectado en $USER_HOME/.openclaw"
    else
        OPENCLAW_FOUND=false
    fi

    if [ -d "$USER_HOME/.claude" ]; then
        CLAUDE_FOUND=true
        AGENTS_DETECTED+=("Claude Code")
        print_ok "Claude Code detectado en $USER_HOME/.claude"
    else
        CLAUDE_FOUND=false
    fi

    if [ -d "$USER_HOME/.gemini" ] || command -v gemini &>/dev/null; then
        GEMINI_FOUND=true
        AGENTS_DETECTED+=("Gemini CLI")
        print_ok "Gemini CLI detectado"
    else
        GEMINI_FOUND=false
    fi

    if command -v codex &>/dev/null || [ -f "$USER_HOME/AGENTS.md" ]; then
        CODEX_FOUND=true
        AGENTS_DETECTED+=("Codex CLI")
        print_ok "Codex CLI detectado"
    else
        CODEX_FOUND=false
    fi

    if [ "${#AGENTS_DETECTED[@]}" -eq 0 ]; then
        print_warn "Ningún agente IA detectado. El método se va a instalar igual."
        print_warn "Después instalá Claude Code (claude.ai/code), Codex (github.com/openai/codex), o Gemini CLI."
    else
        print_ok "Agentes detectados: ${AGENTS_DETECTED[*]}"
    fi
}

# ===== 2. Elegir ubicación del workspace =====
choose_workspace() {
    print_step "Eligiendo ubicación del workspace..."

    # Default: $HOME/mothership-workspace
    DEFAULT_WORKSPACE="$USER_HOME/mothership-workspace"

    if [ "$OPENCLAW_FOUND" = true ]; then
        DEFAULT_WORKSPACE="$USER_HOME/.openclaw/workspace"
    fi

    echo ""
    echo "El workspace es donde van a vivir tus proyectos y memoria."
    read -p "Usar $DEFAULT_WORKSPACE ? [Y/n]: " yn
    yn=${yn:-Y}
    if [[ "$yn" =~ ^[Yy]$ ]]; then
        WORKSPACE="$DEFAULT_WORKSPACE"
    else
        read -p "Path absoluto del workspace: " WORKSPACE
    fi

    mkdir -p "$WORKSPACE"
    print_ok "Workspace: $WORKSPACE"
}

# ===== 3. Copiar templates de workspace =====
install_workspace_files() {
    print_step "Instalando archivos base del workspace..."

    # Backup de archivos existentes (nunca pisar)
    for f in AGENTS.md CROSS_SYNC.md ARTIFACT_INDEX.md PROJECT_REGISTRY.md ARCHIVE_POLICY.md; do
        if [ -f "$WORKSPACE/$f" ]; then
            BACKUP="$WORKSPACE/${f}.bak.$(date -u +%Y%m%dT%H%MZ)"
            cp "$WORKSPACE/$f" "$BACKUP"
            print_warn "Backup: $BACKUP"
        fi
        cp "$SCRIPT_DIR/templates/$f" "$WORKSPACE/$f"
        print_ok "Instalado: $f"
    done

    mkdir -p "$WORKSPACE/projects"
    print_ok "Directorio projects/ creado"
}

# ===== 4. Instalar scripts ejecutables + templates en path predecible =====
install_scripts() {
    print_step "Instalando scripts en $USER_HOME/bin..."
    mkdir -p "$USER_HOME/bin"

    for script in project-init project-sync project-resolve doc-close; do
        cp "$SCRIPT_DIR/scripts/$script" "$USER_HOME/bin/$script"
        chmod +x "$USER_HOME/bin/$script"
        print_ok "Instalado: $USER_HOME/bin/$script"
    done

    # Instalar templates en $HOME/.mothership/ para que project-init los encuentre
    print_step "Instalando templates en $USER_HOME/.mothership/templates/..."
    mkdir -p "$USER_HOME/.mothership/templates"
    cp -r "$SCRIPT_DIR/templates/project-bundle" "$USER_HOME/.mothership/templates/"
    print_ok "Templates instalados"

    # Verificar que $HOME/bin está en PATH
    if [[ ":$PATH:" != *":$USER_HOME/bin:"* ]]; then
        print_warn "$USER_HOME/bin NO está en tu PATH"
        echo "   Agregá esta línea a ~/.bashrc o ~/.zshrc:"
        echo "     export PATH=\"\$HOME/bin:\$PATH\""
    fi
}

# ===== 5. Instalar hooks de Claude Code =====
install_hooks() {
    if [ "$CLAUDE_FOUND" = false ]; then
        print_warn "Skip hooks (Claude Code no detectado)"
        return
    fi

    print_step "Instalando hooks de enforcement..."
    mkdir -p "$USER_HOME/.claude/hooks"

    for hook in bash-budget-guard.sh doc-checklist-guard.sh; do
        cp "$SCRIPT_DIR/hooks/$hook" "$USER_HOME/.claude/hooks/$hook"
        chmod +x "$USER_HOME/.claude/hooks/$hook"
        print_ok "Instalado: $USER_HOME/.claude/hooks/$hook"
    done

    print_warn "Para activar los hooks, agregá esto a ~/.claude/settings.json:"
    cat <<EOF

  "hooks": {
    "PreToolUse": [
      {"matcher": "Bash", "hooks": [{"type": "command", "command": "$USER_HOME/.claude/hooks/bash-budget-guard.sh"}]}
    ],
    "Stop": [
      {"hooks": [{"type": "command", "command": "$USER_HOME/.claude/hooks/doc-checklist-guard.sh"}]}
    ]
  }

EOF
}

# ===== 6. Instalar configuración por-agente (multi-agente) =====
install_agent_configs() {
    print_step "Configurando agentes detectados..."

    # CLAUDE.md
    if [ "$CLAUDE_FOUND" = true ] && [ -f "$SCRIPT_DIR/templates/CLAUDE.md" ]; then
        if [ -f "$USER_HOME/.claude/CLAUDE.md" ]; then
            cp "$USER_HOME/.claude/CLAUDE.md" "$USER_HOME/.claude/CLAUDE.md.bak.$(date -u +%Y%m%dT%H%MZ)"
            print_warn "Backup CLAUDE.md previo"
        fi
        sed "s|{{WORKSPACE}}|$WORKSPACE|g" "$SCRIPT_DIR/templates/CLAUDE.md" > "$USER_HOME/.claude/CLAUDE.md"
        print_ok "CLAUDE.md instalado para Claude Code"
    fi

    # GEMINI.md
    if [ "$GEMINI_FOUND" = true ] && [ -f "$SCRIPT_DIR/templates/GEMINI.md" ]; then
        mkdir -p "$USER_HOME/.gemini"
        if [ -f "$USER_HOME/.gemini/GEMINI.md" ]; then
            cp "$USER_HOME/.gemini/GEMINI.md" "$USER_HOME/.gemini/GEMINI.md.bak.$(date -u +%Y%m%dT%H%MZ)"
            print_warn "Backup GEMINI.md previo"
        fi
        sed "s|{{WORKSPACE}}|$WORKSPACE|g" "$SCRIPT_DIR/templates/GEMINI.md" > "$USER_HOME/.gemini/GEMINI.md"
        print_ok "GEMINI.md instalado para Gemini CLI"
    fi

    # AGENTS.md universal (Codex + cualquier agente que use el estándar)
    if [ -f "$SCRIPT_DIR/templates/AGENTS.md" ]; then
        if [ -f "$USER_HOME/AGENTS.md" ]; then
            cp "$USER_HOME/AGENTS.md" "$USER_HOME/AGENTS.md.bak.$(date -u +%Y%m%dT%H%MZ)"
            print_warn "Backup AGENTS.md previo"
        fi
        cp "$SCRIPT_DIR/templates/AGENTS.md" "$USER_HOME/AGENTS.md"
        print_ok "AGENTS.md universal instalado en $USER_HOME (lo lee Codex y agentes compatibles)"
    fi

    if [ "${#AGENTS_DETECTED[@]}" -eq 0 ]; then
        print_warn "Sin agentes detectados — configs no instaladas. Instalá los configs manualmente cuando agregues un agente."
    fi
}

# ===== 7. Crear primer proyecto demo =====
create_demo_project() {
    print_step "Creando proyecto demo 'mi-primer-proyecto'..."

    DEMO_DIR="$WORKSPACE/projects/mi-primer-proyecto"

    if [ -d "$DEMO_DIR" ]; then
        print_warn "Demo ya existe — skip"
        return
    fi

    mkdir -p "$DEMO_DIR"
    cp -r "$SCRIPT_DIR/templates/project-bundle/"* "$DEMO_DIR/"

    # Personalizar
    sed -i.bak "s|{{SLUG}}|mi-primer-proyecto|g" "$DEMO_DIR"/*.md 2>/dev/null || \
    sed -i "" "s|{{SLUG}}|mi-primer-proyecto|g" "$DEMO_DIR"/*.md 2>/dev/null || true
    rm -f "$DEMO_DIR"/*.bak

    print_ok "Demo creado en $DEMO_DIR"
}

# ===== 7.5. Cleanup source code post-install (v1.1.3+) =====
# Default: ON (privacidad). Skip con --no-cleanup.
cleanup_source_post_install() {
    if [ "$RUN_CLEANUP" = false ]; then
        print_warn "Cleanup post-install skipeado (--no-cleanup flag)"
        return
    fi

    print_step "Limpieza automática del código fuente (paso default por privacidad)..."

    # SCRIPT_DIR es donde vive este install.sh + el resto del starter-pack source
    # Después de instalar, el cliente solo necesita ~/bin + ~/.mothership/templates + el workspace
    # El source crudo (starter-pack/) ya no es necesario y borrarlo evita re-distribución

    PARENT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

    # Borrar el directorio del starter-pack
    if [ -d "$SCRIPT_DIR" ] && [ "$(basename "$SCRIPT_DIR")" = "starter-pack" ]; then
        rm -rf "$SCRIPT_DIR" 2>/dev/null && print_ok "Borrado: $SCRIPT_DIR (source code)"
    fi

    # Borrar tar.gz si está al lado
    for tarball in "$PARENT_DIR"/mothership-starter-v*.tar.gz "$USER_HOME"/mothership-starter-v*.tar.gz "/tmp/mothership-starter"*.tar.gz "/tmp/ms.tar.gz"; do
        if [ -f "$tarball" ]; then
            rm -f "$tarball" && print_ok "Borrado: $tarball (paquete descargado)"
        fi
    done

    # Borrar directorio mothership-starter en home si existe (de git clone)
    if [ -d "$USER_HOME/mothership-starter" ]; then
        rm -rf "$USER_HOME/mothership-starter" && print_ok "Borrado: $USER_HOME/mothership-starter"
    fi

    print_ok "Source code limpiado. La instalación quedó funcional sin dejar fuentes."
}

# ===== 8. Mensaje final =====
print_success() {
    echo ""
    echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}${BOLD}║              ✓ INSTALACIÓN COMPLETA                       ║${NC}"
    echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BOLD}Tu workspace:${NC} $WORKSPACE"
    echo ""
    printf "${BOLD}Próximos pasos:${NC}\n"
    printf "  1. Leé ${BLUE}%s/CHEATSHEET.md${NC} (los 10 comandos esenciales)\n" "$SCRIPT_DIR"
    printf "  2. Leé ${BLUE}%s/METHOD.md${NC} (cómo funciona el método)\n" "$SCRIPT_DIR"
    printf "  3. Abrí Claude Code dentro de %s\n" "$WORKSPACE"
    printf "  4. Probá decirle: 'trabajemos en mi-primer-proyecto'\n"
    printf "  5. Cuando hagas un cambio, ejecutá: ${BLUE}doc-close mi-primer-proyecto${NC}\n"
    echo ""
    printf "${BOLD}Comandos disponibles:${NC}\n"
    printf "  ${BLUE}project-init <slug>${NC}      crear proyecto nuevo\n"
    printf "  ${BLUE}project-sync <slug>${NC}      backup local del proyecto\n"
    printf "  ${BLUE}project-resolve <alias>${NC}  resolver alias a slug canonical\n"
    printf "  ${BLUE}doc-close <slug>${NC}         validar checklist de documentación\n"
    echo ""
    printf "${YELLOW}¿Dudas?${NC} Escribime al WhatsApp/email del onboarding.\n"
    echo ""
}

# ===== Main =====
main() {
    print_header
    detect_environment
    choose_workspace
    install_workspace_files
    install_scripts
    install_hooks
    install_agent_configs
    create_demo_project
    cleanup_source_post_install
    print_success
}

main "$@"
