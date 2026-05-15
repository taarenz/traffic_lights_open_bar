# OpenBar Traffic Lights Patcher

<img width="1022" height="528" alt="Screenshot From 2026-05-15 14-00-38" src="https://github.com/user-attachments/assets/1b73c2c3-b06c-4576-b44a-460ba03e0229" />
<img width="1020" height="528" alt="Screenshot From 2026-05-15 13-59-45" src="https://github.com/user-attachments/assets/2c5905b3-7eda-472d-bc49-5206eca62d43" />
<img width="1020" height="531" alt="Screenshot From 2026-05-15 13-58-50" src="https://github.com/user-attachments/assets/470f269c-545f-41b2-b942-83da7a3c7abd" />


> macOS-style window control buttons for GNOME's OpenBar extension.

![Bash](https://img.shields.io/badge/shell-bash-blue) ![Version](https://img.shields.io/badge/version-1.0.0-green) ![License](https://img.shields.io/badge/license-MIT-lightgrey)

---

## Overview

**OpenBar Traffic Lights Patcher** is a Bash script that injects custom CSS into the [OpenBar GNOME Shell extension](https://extensions.gnome.org/extension/6580/openbar/) to replace the default window control buttons with circular, macOS-style traffic lights.

The patch surgically modifies `stylesheets.js` inside the OpenBar extension directory, adding a themed CSS block that reskins the close, minimize, and maximize buttons across your entire GNOME desktop — no manual file editing required.

---

## Features

- 🎨 **10 built-in color themes** — purple, blue, green, red, orange, pink, teal, yellow, indigo, gray
- 🔵 Smooth circular buttons with hover transitions
- 🌑 Backdrop/unfocused state support
- 💾 Automatic backup of the original `stylesheets.js`
- ♻️ Idempotent — safe to run multiple times; previous patches are replaced cleanly
- 🗑️ One-command uninstall

---

## Requirements

- GNOME Shell
- [OpenBar extension](https://extensions.gnome.org/extension/6580/openbar/) installed and enabled (`openbar@neuromorph`)
- Bash 4+

---

## Installation

Clone or download the script, then make it executable:

```bash
chmod +x traffic_lights_open_bar.sh
```

---

## Usage

```
./traffic_lights_open_bar.sh [OPTIONS]
```

### Options

| Flag | Description |
|---|---|
| `-c`, `--color THEME` | Apply a specific color theme (default: `purple`) |
| `-u`, `--uninstall` | Remove the patch from OpenBar |
| `-l`, `--list-colors` | List all available themes |
| `-v`, `--version` | Show script version |
| `-h`, `--help` | Show help message |

---

## Examples

**Install with the default purple theme:**
```bash
./traffic_lights_open_bar.sh
```

**Install with a specific theme:**
```bash
./traffic_lights_open_bar.sh --color blue
./traffic_lights_open_bar.sh --color teal
./traffic_lights_open_bar.sh --color red
```

**List all available themes:**
```bash
./traffic_lights_open_bar.sh --list-colors
```

**Remove the patch:**
```bash
./traffic_lights_open_bar.sh --uninstall
```

---

## Available Themes

| Theme | Close | Maximize | Minimize |
|---|---|---|---|
| `purple` | `#3b0066` | `#5a1a9e` | `#7b3fe4` |
| `blue` | `#1e3a8a` | `#2563eb` | `#60a5fa` |
| `green` | `#14532d` | `#16a34a` | `#4ade80` |
| `red` | `#7f1d1d` | `#dc2626` | `#f87171` |
| `orange` | `#7c2d12` | `#ea580c` | `#fb923c` |
| `pink` | `#831843` | `#db2777` | `#f472b6` |
| `teal` | `#134e4a` | `#14b8a6` | `#5eead4` |
| `yellow` | `#713f12` | `#eab308` | `#fde047` |
| `indigo` | `#312e81` | `#4f46e5` | `#818cf8` |
| `gray` | `#374151` | `#6b7280` | `#9ca3af` |

Each theme defines three shades (dark → medium → light) for close, maximize, and minimize respectively, plus lighter hover variants for each.

---

## After Patching

Reload the OpenBar extension to apply the changes:

```bash
gnome-extensions disable openbar@neuromorph
gnome-extensions enable openbar@neuromorph
```

Or toggle it directly from the GNOME Extensions app.

---

## How It Works

The script targets the `stylesheets.js` file inside the OpenBar extension directory:

```
~/.local/share/gnome-shell/extensions/openbar@neuromorph/stylesheets.js
```

It locates the line `return gtkstring;` (the anchor point where OpenBar assembles its CSS output) and injects a self-contained CSS block just before it. The block is wrapped in markers:

```
// ===== CUSTOM TRAFFIC LIGHT BUTTONS =====
...
// ===== END CUSTOM TRAFFIC LIGHT BUTTONS =====
```

These markers allow the script to cleanly remove or replace the patch on subsequent runs without touching anything else in the file.

A backup of the original file is saved to `stylesheets.js.bak` the first time the script runs.

---

## Uninstalling

Run the script with `--uninstall` to remove the injected CSS block:

```bash
./traffic_lights_open_bar.sh --uninstall
```

To fully restore the original file, use the backup:

```bash
cp ~/.local/share/gnome-shell/extensions/openbar@neuromorph/stylesheets.js.bak \
   ~/.local/share/gnome-shell/extensions/openbar@neuromorph/stylesheets.js
```

---

## Notes

- The backup (`stylesheets.js.bak`) is created only once. If you need a fresh backup after manual edits, delete the `.bak` file first.
- Updating the OpenBar extension may overwrite `stylesheets.js`. If that happens, simply re-run the patcher.
- The script modifies only the `gtkstring` CSS output; it does not touch any other OpenBar logic or settings.

---

## License

MIT — do whatever you want with it.
