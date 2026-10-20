/**
 * highlight.ts: the pure half of code-colors. Splits a reply's markdown into
 * prose and code fences of the languages in languages.ts, tokenizes code with
 * those rules, and holds the palettes. No `$`, no IO; register.tsx draws it.
 */

import { FENCE_LANGS, LANGUAGES, type Lang, type Token, type TokenKind } from './languages'

export type { Lang, Token, TokenKind } from './languages'

export type PaletteName = 'auto' | 'mine' | 'mine-light' | 'github' | 'modern' | 'minimal'

export type Scheme = 'dark' | 'light'

export type Palette = Record<TokenKind, string | undefined>

export type Segment =
  | { kind: 'prose'; text: string }
  | { kind: 'code'; lang: Lang; source: string; palette?: PaletteName }

/** Token colors; `undefined` keeps the terminal's default color. */
export const PALETTES: Record<Exclude<PaletteName, 'auto'>, Palette> = {
  // GitHub Dark Default, matching the Neovim github_dark_default colorscheme:
  // prettylights keyword/string/constant/comment/entity/variable
  mine: {
    keyword: '#ff7b72',
    type: '#ffa657',
    name: '#ffa657', // class/struct/enum names share the theme's type color
    string: '#a5d6ff',
    number: '#79c0ff',
    comment: '#8b949e',
    function: '#d2a8ff',
    punct: undefined,
    plain: undefined,
  },
  // GitHub Light Default, matching the Neovim github_light_default colorscheme
  'mine-light': {
    keyword: '#cf222e',
    type: '#953800',
    name: '#953800',
    string: '#0a3069',
    number: '#0550ae',
    comment: '#57606a',
    function: '#6639ba',
    punct: undefined,
    plain: undefined,
  },
  // GitHub Dark: primer/github-vscode-theme src/theme.js, @primer/primitives 7.10.0 dark scale
  github: {
    keyword: '#FF7B72', // red[3]
    type: '#FFA657', // orange[2], entity.name
    name: '#FFA657',
    string: '#A5D6FF', // blue[1]
    number: '#79C0FF', // blue[2], constant
    comment: '#8B949E', // gray[3]
    function: '#D2A8FF', // purple[2]
    punct: undefined,
    plain: undefined,
  },
  // VS Code Default Dark Modern: microsoft/vscode theme-defaults dark_vs.json + dark_plus.json
  modern: {
    keyword: '#569CD6',
    type: '#4EC9B0',
    name: '#4EC9B0',
    string: '#CE9178',
    number: '#B5CEA8',
    comment: '#6A9955',
    function: '#DCDCAA',
    punct: undefined,
    plain: undefined,
  },
  // GitHub Dark hues on keywords, strings and comments only
  minimal: {
    keyword: '#FF7B72',
    type: undefined,
    name: undefined,
    string: '#A5D6FF',
    number: undefined,
    comment: '#8B949E',
    function: undefined,
    punct: undefined,
    plain: undefined,
  },
}

export const DEFAULT_PALETTE: PaletteName = 'auto'

/** `auto` follows the detected terminal scheme; any other name is fixed. */
export function paletteFor(name: PaletteName, scheme: Scheme): Palette {
  if (name === 'auto') return PALETTES[scheme === 'light' ? 'mine-light' : 'mine']
  return PALETTES[name]
}

const isPaletteName = (name: string): name is PaletteName => name === 'auto' || Object.hasOwn(PALETTES, name)

const FENCE = /^```([\w+-]*)(?:[ \t]+([\w-]+))?[ \t]*\n([\s\S]*?)\n```[ \t]*(?:\n|$)/gm

export function splitFences(markdown: string): Segment[] {
  const segments: Segment[] = []
  let proseStart = 0
  for (const match of markdown.matchAll(FENCE)) {
    const lang = FENCE_LANGS[(match[1] ?? '').toLowerCase()]
    if (!lang) continue // its whole fence stays inside the surrounding prose
    const prose = markdown.slice(proseStart, match.index)
    if (prose) segments.push({ kind: 'prose', text: prose })
    const palette = match[2] ?? ''
    const source = match[3] ?? ''
    segments.push(isPaletteName(palette) ? { kind: 'code', lang, source, palette } : { kind: 'code', lang, source })
    proseStart = match.index + match[0].length
  }
  const rest = markdown.slice(proseStart)
  if (rest) segments.push({ kind: 'prose', text: rest })
  return segments
}

function matchAt(source: string, at: number, lang: Lang): Token {
  const { rules, classifyWord } = LANGUAGES[lang]
  for (const { kind, pattern } of rules) {
    pattern.lastIndex = at
    const match = pattern.exec(source)
    if (!match) continue
    const text = match[0]
    if (kind !== 'word') return { kind, text }
    return { kind: classifyWord(text, source.slice(0, at), source.slice(at + text.length)), text }
  }
  return { kind: 'plain', text: source.charAt(at) }
}

/** Tokens in source order; joined, their texts are `source` exactly. */
export function tokenize(source: string, lang: Lang): Token[] {
  const tokens: Token[] = []
  for (let at = 0; at < source.length; ) {
    const token = matchAt(source, at, lang)
    const last = tokens.at(-1)
    if (token.kind === 'plain' && last?.kind === 'plain') tokens[tokens.length - 1] = { kind: 'plain', text: last.text + token.text }
    else tokens.push(token)
    at += token.text.length
  }
  return tokens
}

/** The tokens of each source line; a token spanning lines is split and keeps its kind. */
export function toLines(source: string, lang: Lang): Token[][] {
  const lines: Token[][] = [[]]
  for (const { kind, text } of tokenize(source, lang)) {
    text.split('\n').forEach((piece, i) => {
      if (i > 0) lines.push([])
      if (piece) lines.at(-1)?.push({ kind, text: piece })
    })
  }
  return lines
}
