# Revontuli theme for editors and terminals

**Date:** 2026-06-28
**Status:** Approved (design)

## Goal

Add the [Revontuli](https://git.sr.ht/~akselmo/Revontuli) colorscheme to every
editor and terminal managed by these dotfiles, **Ghostty included**. Revontuli
is a high-contrast dark theme (Finnish for "aurora borealis"); upstream also
defines a pure-black "Night" variant and a light variant.

## Decisions (from brainstorming)

- **Variants:** Dark + Night + Light, scaled to what each tool can support.
- **Activation:** Add the theme files *and* switch the active **dark** theme to
  Revontuli where policy allows (Konsole excepted — see below). Active **light**
  theme is **Pierre Light** (existing), not Revontuli Light.
- **Light terminal palette:** Skipped. Upstream ships ANSI palettes only for the
  dark variants, so wezterm/konsole get Dark + Night only; no invented light
  terminal palette.
- **Ghostty:** Active dark → Revontuli; light stays `doom-one-light`. Dark +
  Night palette files added (`themes/Revontuli`, `themes/Revontuli-night`).

## Canonical palette

Upstream's README names the **Kate theme as the canonical syntax source**, so
editor syntax colors are ported from `Kate/revontuli.theme` `text-styles`, giving
uniform highlighting across nvim and zed.

### Backgrounds / base

| Variant   | Background | Foreground | Current line | Selection |
| --------- | ---------- | ---------- | ------------ | --------- |
| Revontuli | `#202020`  | `#ffffff`  | `#1d1d1d`    | `#144364` |
| Night     | `#000000`  | `#ffffff`  | `#0d0d0d`    | `#144364` |
| Light     | `#f2f2f2`  | `#000000`  | `#e0dce0`    | `#bcd4ef` |

### Syntax (Kate canonical, dark)

| Token                          | Color     |
| ------------------------------ | --------- |
| Normal                         | `#ffffff` |
| Comment                        | `#707070` |
| Keyword                        | `#33bbff` (bold) |
| Control flow                   | `#33ffa0` (italic) |
| Operator                       | `#33ffa0` |
| Function                       | `#838fff` (bold) |
| Type / BuiltIn / Constant / DataType | `#33ffff` |
| String                         | `#00ee00` |
| Char                           | `#33bbff` |
| Number (DecVal/Float/BaseN)    | `#d970ff` (bold) |
| Variable                       | `#ff9233` |
| Import                         | `#d970ff` |
| Attribute / Preprocessor / SpecialChar / SpecialString | `#ffe033` |
| Annotation / Extension / Function-alt | `#838fff` |
| Others                         | `#5fff33` |
| Error                          | `#ff3344` |
| Warning / Neutral              | `#ff9233` |
| Positive                       | `#00ec00` |

Light-variant syntax uses the README's light accent set (red `#c82835`, green
`#4bc828`, blue `#2885c8`, magenta `#be62df`, cyan `#28c8c8`, neutral `#c87028`)
on `#000000` text where the dark accents would wash out on `#f2f2f2`.

### Terminal ANSI (Konsole/Xresources upstream)

Dark (`Revontuli`, bg `#202020`):

```
0 #606060  1 #ff3344  2 #5fff33  3 #ff9233  4 #33bbff  5 #d970ff  6 #33ffff  7 #cccccc
8 #808080  9 #ff1d3f 10 #57ff1a 11 #ff7513 12 #15a5ff 13 #d258ff 14 #00ddff 15 #ffffff
```

Night (bg `#000000`) uses upstream `revontulinight.colorscheme` values
(black `#414141`, green `#5fff33`, blue `#33aaff`, white `#dfdfdf`, …).

## Files and wiring

The `nvim/colors`, `zed/themes`, and `wezterm/colors` directories are symlinked
**whole**; Konsole colorschemes are **glob**-linked. New files therefore link
automatically — **`install.conf.yaml` needs no changes.**

| Tool    | New files                                                                 | Variants            | Activation |
| ------- | ------------------------------------------------------------------------- | ------------------- | ---------- |
| nvim    | `editors/nvim/colors/revontuli.lua`, `revontuli-night.lua`, `revontuli-light.lua` | Dark, Night, Light | Edit `lua/plugins/themes.lua`: `set_dark_mode` → `colorscheme("revontuli")`, `set_light_mode` → `colorscheme("pierre-light")` |
| zed     | `editors/zed/themes/revontuli.json` (3 themes in one family file)          | Dark, Night, Light | Edit `editors/zed/settings.json` `theme`: `dark` → `Revontuli`, `light` → `Pierre Light` (preserve header + inline comments) |
| wezterm | `terminals/wezterm/colors/Revontuli.toml`, `Revontuli Night.toml`          | Dark, Night         | Edit `.wezterm.lua:64` → `color_scheme = is_dark and "Revontuli" or "Pierre Light"` |
| konsole | `terminals/konsole/colorschemes/Revontuli.colorscheme`, `Revontuli Night.colorscheme` | Dark, Night | **Manual** — repo policy forbids managing Konsole profiles; user selects the scheme in Konsole settings |
| ghostty | `terminals/ghostty/themes/Revontuli`, `Revontuli-night`                    | Dark, Night         | Edit `config.ghostty` `theme` → `dark:Revontuli,light:doom-one-light` |

The **Night** variant is an available-but-inactive alternate in every tool;
active dark is the `#202020` Revontuli.

## nvim colorscheme format

Each `colors/*.lua` mirrors the existing `pierre-*.lua`: `highlight clear` +
`syntax reset` guard, `vim.g.colors_name`, `vim.o.background`, a local `hl`
helper, `terminal_color_0..15`, then base-UI / syntax / treesitter (`@…`) /
diagnostics / diff-git highlight groups. `colors_name` must equal the filename.

## zed theme format

`revontuli.json` follows `pierre.json`/`doom-one.json`: top-level
`$schema`/`name`/`author`/`themes`, with three theme objects (`Revontuli`,
`Revontuli Night`, `Revontuli Light`), each carrying the full `style` UI key set
(~126 keys) plus a `syntax` map. UI keys derived from the README UI palette;
`syntax` from the Kate canonical table.

## Out of scope

- No light terminal palette (wezterm/konsole/ghostty).
- No Konsole profile/`konsolerc` changes.
- No change to the icon themes or any non-color setting.

## Verification

- `./install -v` must succeed with no errors (no new symlink entries expected).
- `pre-commit run --all-files` (trailing-whitespace hook).
- nvim: `:colorscheme revontuli` / `revontuli-night` / `revontuli-light` load
  without errors.
- Commits: per-tool, Conventional Commits (`feat(nvim): …`, `feat(zed): …`,
  `feat(wezterm): …`, `feat(konsole): …`), each independently installable.
