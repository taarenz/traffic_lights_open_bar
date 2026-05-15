#!/usr/bin/env bash

set -Eeuo pipefail

# =============================================================================
# OPENBAR TRAFFIC LIGHTS PATCHER
# =============================================================================
#
# Adds customizable macOS-style traffic light window buttons
# to the GNOME OpenBar extension.
#
# Repository:
# https://github.com/yourname/openbar-traffic-lights
#
# =============================================================================

SCRIPT_NAME="$(basename "$0")"
VERSION="1.0.0"

TARGET="$HOME/.local/share/gnome-shell/extensions/openbar@neuromorph/stylesheets.js"
BACKUP="${TARGET}.bak"

MARKER_START="// ===== CUSTOM TRAFFIC LIGHT BUTTONS ====="
MARKER_END="// ===== END CUSTOM TRAFFIC LIGHT BUTTONS ====="

ANCHOR='  return gtkstring;'

# =============================================================================
# UI HELPERS
# =============================================================================

info() {
  echo "[INFO] $*"
}

success() {
  echo "[ OK ] $*"
}

warn() {
  echo "[WARN] $*"
}

error() {
  echo "[FAIL] $*" >&2
  exit 1
}

# =============================================================================
# HELP
# =============================================================================

show_help() {
  cat <<EOF
OpenBar Traffic Lights Patcher

DESCRIPTION
    Adds customizable macOS-style traffic light buttons
    to the GNOME OpenBar extension.

USAGE
    $SCRIPT_NAME [OPTIONS]

OPTIONS
    -c, --color THEME
        Select a color theme.

    -u, --uninstall
        Remove the patch from OpenBar.

    -l, --list-colors
        Show all available themes.

    -v, --version
        Show script version.

    -h, --help
        Show this help message.

AVAILABLE THEMES
    purple   blue     green    red
    orange   pink     teal     yellow
    indigo   gray

EXAMPLES
    Install with default theme:
        $SCRIPT_NAME

    Install with blue theme:
        $SCRIPT_NAME --color blue

    Remove patch:
        $SCRIPT_NAME --uninstall

NOTES
    A backup of stylesheets.js is automatically created.

    After patching, reload OpenBar:

        gnome-extensions disable openbar@neuromorph
        gnome-extensions enable openbar@neuromorph

EOF
}

list_colors() {
  cat <<EOF
Available themes:

- purple
- blue
- green
- red
- orange
- pink
- teal
- yellow
- indigo
- gray
EOF
}

# =============================================================================
# COLOR THEMES
# =============================================================================

load_color_palette() {
  case "${1:-purple}" in
  purple)
    CLOSE="#3b0066"
    MAXIMIZE="#5a1a9e"
    MINIMIZE="#7b3fe4"
    HOVER_CLOSE="#7a2cff"
    HOVER_MAX="#9b5cff"
    HOVER_MIN="#c299ff"
    ;;

  blue)
    CLOSE="#1e3a8a"
    MAXIMIZE="#2563eb"
    MINIMIZE="#60a5fa"
    HOVER_CLOSE="#3b82f6"
    HOVER_MAX="#60a5fa"
    HOVER_MIN="#93c5fd"
    ;;

  green)
    CLOSE="#14532d"
    MAXIMIZE="#16a34a"
    MINIMIZE="#4ade80"
    HOVER_CLOSE="#22c55e"
    HOVER_MAX="#4ade80"
    HOVER_MIN="#86efac"
    ;;

  red)
    CLOSE="#7f1d1d"
    MAXIMIZE="#dc2626"
    MINIMIZE="#f87171"
    HOVER_CLOSE="#ef4444"
    HOVER_MAX="#f87171"
    HOVER_MIN="#fca5a5"
    ;;

  orange)
    CLOSE="#7c2d12"
    MAXIMIZE="#ea580c"
    MINIMIZE="#fb923c"
    HOVER_CLOSE="#f97316"
    HOVER_MAX="#fb923c"
    HOVER_MIN="#fdba74"
    ;;

  pink)
    CLOSE="#831843"
    MAXIMIZE="#db2777"
    MINIMIZE="#f472b6"
    HOVER_CLOSE="#ec4899"
    HOVER_MAX="#f472b6"
    HOVER_MIN="#f9a8d4"
    ;;

  teal)
    CLOSE="#134e4a"
    MAXIMIZE="#14b8a6"
    MINIMIZE="#5eead4"
    HOVER_CLOSE="#2dd4bf"
    HOVER_MAX="#5eead4"
    HOVER_MIN="#99f6e4"
    ;;

  yellow)
    CLOSE="#713f12"
    MAXIMIZE="#eab308"
    MINIMIZE="#fde047"
    HOVER_CLOSE="#facc15"
    HOVER_MAX="#fde047"
    HOVER_MIN="#fef08a"
    ;;

  indigo)
    CLOSE="#312e81"
    MAXIMIZE="#4f46e5"
    MINIMIZE="#818cf8"
    HOVER_CLOSE="#6366f1"
    HOVER_MAX="#818cf8"
    HOVER_MIN="#c7d2fe"
    ;;

  gray)
    CLOSE="#374151"
    MAXIMIZE="#6b7280"
    MINIMIZE="#9ca3af"
    HOVER_CLOSE="#4b5563"
    HOVER_MAX="#9ca3af"
    HOVER_MIN="#d1d5db"
    ;;

  *)
    error "Unknown theme: $1"
    ;;
  esac
}

# =============================================================================
# BUILD CSS BLOCK
# =============================================================================

build_js_block() {
  cat <<EOF
  ${MARKER_START}
  gtkstring += \
  \`
    windowcontrols {
        border-spacing: 0;
    }

    windowcontrols > button,
    button.titlebutton {
        padding: 0;
        margin: 0;
        min-width: 16px;
        min-height: 16px;
        border-radius: 999px;
        -GtkWidget-focus-padding: 0;
        -GtkWidget-focus-line-width: 0;
    }

    windowcontrols > button > image,
    button.titlebutton > image {
        min-width: 16px;
        min-height: 16px;

        margin: 0 4px;
        padding: 0;

        border-radius: 999px;

        box-shadow: inset 0 0 0 1px rgba(0,0,0,0.25);

        background-size: 16px 16px;

        -gtk-icon-size: 10px;

        color: transparent;

        transition:
            background-color 0.15s ease,
            color 0.15s ease,
            opacity 0.15s ease;
    }

    windowcontrols > button:hover > image,
    button.titlebutton:hover > image {
        color: black;
        opacity: 1;
    }

    windowcontrols > button:backdrop > image,
    button.titlebutton:backdrop {
        opacity: 0.6;
    }

    .titlebar .right { margin-right: 10px; }
    .titlebar .left  { margin-left: 6px; }

    button.titlebutton.close,
    windowcontrols > button.close > image {
        background-color: ${CLOSE};
    }

    button.titlebutton.close:hover,
    windowcontrols > button.close:hover > image {
        background-color: ${HOVER_CLOSE};
    }

    button.titlebutton.minimize,
    windowcontrols > button.minimize > image {
        background-color: ${MINIMIZE};
    }

    button.titlebutton.minimize:hover,
    windowcontrols > button.minimize:hover > image {
        background-color: ${HOVER_MIN};
    }

    button.titlebutton.maximize,
    windowcontrols > button.maximize > image {
        background-color: ${MAXIMIZE};
    }

    button.titlebutton.maximize:hover,
    windowcontrols > button.maximize:hover > image {
        background-color: ${HOVER_MAX};
    }

    button.titlebutton.close:backdrop,
    button.titlebutton.minimize:backdrop,
    button.titlebutton.maximize:backdrop {
        opacity: 0.85;
    }
  \`
  ${MARKER_END}
EOF
}

# =============================================================================
# FILE OPERATIONS
# =============================================================================

check_target() {
  [[ -f "$TARGET" ]] || error "stylesheets.js not found: $TARGET"
}

create_backup() {
  if [[ ! -f "$BACKUP" ]]; then
    cp "$TARGET" "$BACKUP"
    success "Backup created: $BACKUP"
  else
    info "Backup already exists"
  fi
}

remove_existing_block() {
  if grep -qF "$MARKER_START" "$TARGET"; then
    sed -i "\\|$MARKER_START|,\\|$MARKER_END|d" "$TARGET"
    success "Previous patch removed"
  fi
}

inject_block() {
  local block="$1"

  grep -qF "$ANCHOR" "$TARGET" || error "Injection anchor not found"

  awk -v block="$block" '
    $0 == "  return gtkstring;" && !done {
      print block
      done=1
    }
    {
      print
    }
  ' "$TARGET" > "${TARGET}.tmp"

  mv "${TARGET}.tmp" "$TARGET"

  success "Patch injected successfully"
}

reload_hint() {
  cat <<EOF

Reload OpenBar to apply changes:

    gnome-extensions disable openbar@neuromorph
    gnome-extensions enable openbar@neuromorph

EOF
}

# =============================================================================
# ARGUMENT PARSING
# =============================================================================

COLOR="purple"
ACTION="install"

while [[ $# -gt 0 ]]; do
  case "$1" in

    -c|--color)
      [[ $# -ge 2 ]] || error "Missing theme name"
      COLOR="$2"
      shift 2
      ;;

    -u|--uninstall)
      ACTION="uninstall"
      shift
      ;;

    -l|--list-colors)
      list_colors
      exit 0
      ;;

    -v|--version)
      echo "$SCRIPT_NAME v$VERSION"
      exit 0
      ;;

    -h|--help)
      show_help
      exit 0
      ;;

    *)
      error "Unknown option: $1"
      ;;
  esac
done

# =============================================================================
# MAIN
# =============================================================================

info "OpenBar Traffic Lights Patcher"

check_target
create_backup

if [[ "$ACTION" == "uninstall" ]]; then
  remove_existing_block
  success "Patch removed successfully"
  exit 0
fi

load_color_palette "$COLOR"

BLOCK="$(build_js_block)"

remove_existing_block
inject_block "$BLOCK"

success "Theme installed: $COLOR"

reload_hint

