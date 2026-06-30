# Tango Dark + Light theme for editors and terminals

**Date:** 2026-06-30
**Status:** Approved (design)

## Goal

Add the **Tango** colorscheme (Dark + Light) to every editor and terminal
managed by these dotfiles, plus Claude Code, and set Tango as the **active**
dark/light pair where repo policy allows. Tango is the freedesktop / Tango
Desktop Project palette popularised as a built-in terminal preset.

## Decisions (from brainstorming)

- **Source of truth:** the **iTerm2 / Windows Terminal "Tango Dark" + "Tango
  Light"** presets (chosen over GNOME-aluminium and the saturated
  Adapted/Half-Adapted variants via live visual comparison).
- **Variants:** Dark + Light only. No Night, no Adapted, no GNOME-aluminium
  variant shipped.
- **Activation:** add the theme files **and** switch the active **dark** theme
  to Tango Dark and active **light** theme to Tango Light, in every tool except
  Konsole (policy — files only, user selects manually) and Claude Code (custom
  themes can't auto-pair — pinned to Tango Dark; light selectable manually).
- **Scope includes Claude Code** (`claude/themes/`), which the Revontuli port
  skipped.
- **Out of scope:** zsh-patina and starship — both use ANSI-named colors, so
  they follow the terminal palette automatically and need no per-theme file.

## Canonical palette

True Tango 16-color ANSI (identical in Dark and Light; only bg/fg/cursor flip):

```
0 #000000  1 #cc0000  2 #4e9a06  3 #c4a000  4 #3465a4  5 #75507b  6 #06989a  7 #d3d7cf
8 #555753  9 #ef2929 10 #8ae234 11 #fce94f 12 #729fcf 13 #ad7fa8 14 #34e2e2 15 #eeeeec
```

Note: cyan slots `6 #06989a` / `14 #34e2e2` are GNOME/freedesktop additions —
the official 27-colour Tango palette has no teal hue. Kept as-is to match every
existing Tango terminal preset.

### Backgrounds / base

| Variant     | Background | Foreground | Cursor    | Selection |
| ----------- | ---------- | ---------- | --------- | --------- |
| Tango Dark  | `#000000`  | `#d3d7cf`  | `#ffffff` | `#555753` |
| Tango Light | `#ffffff`  | `#555753`  | `#000000` | `#d3d7cf` |

### Syntax mapping

No upstream "canonical syntax source" exists for Tango (unlike Revontuli's Kate
theme). Syntax colours are derived from the palette — **bright** ANSI tints on
the dark bg, **base** tints on the light bg — for legible contrast on each.

| Token                    | Dark      | Light     |
| ------------------------ | --------- | --------- |
| Normal / variable / operator | `#d3d7cf` | `#555753` |
| Comment                  | `#888a85` | `#888a85` |
| Keyword / control flow   | `#729fcf` | `#3465a4` |
| Function                 | `#fce94f` | `#c4a000` |
| Type / class / builtin   | `#ad7fa8` | `#75507b` |
| String                   | `#8ae234` | `#4e9a06` |
| Number / constant        | `#fcaf3e` | `#ce5c00` |
| Char / special / cyan    | `#34e2e2` | `#06989a` |
| Error                    | `#ef2929` | `#cc0000` |
| Warning                  | `#fce94f` | `#c4a000` |

(`#fcaf3e`/`#ce5c00` are Tango Orange — in the 27-colour palette though not an
ANSI slot — used for numbers/constants so they read distinct from strings.)

## Files and wiring

The `nvim/colors`, `zed/themes`, `wezterm/colors`, `ghostty/themes`, and
`claude/themes` directories are symlinked **whole**; Konsole colorschemes are
**glob**-linked. New files therefore link automatically — **`install.conf.yaml`
needs no changes.**

| Tool    | New files | Variants | Activation |
| ------- | --------- | -------- | ---------- |
| nvim    | `colors/tango-dark.lua`, `tango-light.lua` | Dark, Light | `lua/plugins/themes.lua`: `set_dark_mode` → `colorscheme("tango-dark")`, `set_light_mode` → `colorscheme("tango-light")` |
| zed     | `themes/tango.json` (2 themes in one family file) | Dark, Light | `settings.json` `theme`: `dark` → `Tango Dark`, `light` → `Tango Light` (preserve header + inline comments) |
| wezterm | `colors/Tango Dark.toml`, `Tango Light.toml` | Dark, Light | `.wezterm.lua:64` → `color_scheme = is_dark and "Tango Dark" or "Tango Light"` |
| konsole | `colorschemes/Tango Dark.colorscheme`, `Tango Light.colorscheme` | Dark, Light | **Manual** — repo policy forbids managing Konsole profiles; user selects scheme in Konsole settings |
| ghostty | `themes/Tango Dark`, `Tango Light` | Dark, Light | `config.ghostty:22` → `theme = dark:Tango Dark,light:Tango Light` |
| claude  | `themes/tango-dark.json`, `tango-light.json` | Dark, Light | `claude/settings.json` `"theme": "custom:tango-dark"`. Claude Code's `"auto"` only switches **built-in** themes and cannot auto-pair two custom themes by `base`, so only one custom theme can be active — pinned to dark; `tango-light` available via `/theme` or `"theme": "custom:tango-light"` |

## Per-tool format notes

Mirror the existing sibling files exactly:

- **nvim** `colors/*.lua`: like `pierre-*.lua` — `highlight clear` + `syntax
  reset` guard, `vim.g.colors_name` (must equal filename), `vim.o.background`,
  local `hl` helper, `terminal_color_0..15`, then base-UI / syntax / treesitter
  (`@…`) / diagnostics / diff-git groups.
- **zed** `tango.json`: like `pierre.json` — top-level `$schema`/`name`/`author`/
  `themes`, two theme objects (`Tango Dark`, `Tango Light`), each with the full
  `style` UI key set + a `syntax` map.
- **wezterm** `*.toml`: like `Pierre Dark.toml` — `[colors]` with `foreground`,
  `background`, `cursor_*`, `selection_*`, `ansi` (8), `brights` (8).
- **konsole** `*.colorscheme`: like `Pierre Dark.colorscheme` — INI with
  `Background`/`Foreground`/`Color0..7` (+`Intense`) RGB triples.
- **ghostty** `themes/*`: like `pierre-dark` — `palette = N=#hex` ×16,
  `background`, `foreground`, `cursor-color`, `selection-*`.
- **claude** `themes/*.json`: like `pierre-dark.json` — Claude Code custom theme
  JSON; mirror its key set.

## Out of scope

- No Night / Adapted / GNOME-aluminium variants.
- No zsh-patina or starship theme file (ANSI-named, auto-follow palette).
- No Konsole profile / `konsolerc` changes.
- No icon-theme or non-colour settings.

## Verification

- `./install -v` succeeds, no errors (no new symlink entries expected).
- `pre-commit run --all-files` (trailing-whitespace hook).
- nvim: `:colorscheme tango-dark` / `tango-light` load without error.
- Commits: per-tool, Conventional Commits (`feat(nvim): …`, `feat(zed): …`,
  `feat(wezterm): …`, `feat(konsole): …`, `feat(ghostty): …`,
  `feat(claude): …`), each independently installable.
