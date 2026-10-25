import type { EngineInterface, Register, RenderNode } from 'claude-code'

import { CHANGED_WORD_TINT, DIFF_TINT, diffRows, readPatch, summarize, type DiffRow } from './diff'
import {
  DEFAULT_PALETTE,
  paletteFor,
  splitFences,
  toLines,
  type Lang,
  type PaletteName,
  type Scheme,
} from './highlight'
import { langFromPath } from './languages'

/**
 * code-colors: draws code in Claude's replies and in Edit/Write diffs with our
 * own palette (anthropics/claude-code#48636). The default palette `auto` picks
 * GitHub Dark or Light from the terminal's scheme; a fence can pin one instead
 * (```ts mine-light). Languages are in languages.ts (SQL, TS/JS/JSX, Python,
 * Rust, Terraform/HCL).
 *
 * Replies: the engine's drawing is opaque (`{ type: 'engine', ref }`), so each
 * prose segment is drawn by the engine through `next` (keeping the reply bullet
 * and Markdown styling) and only the code segments are ours.
 * Diffs: the Edit/Write diff and its summary line are ours; backgrounds use the
 * engine's theme keys, so they follow the person's theme. Render-only: nothing
 * stored is changed.
 */

const CODE_INDENT = 2 // lines up with the prose after the reply bullet

const SCHEME_TTL_MS = 30_000
let schemeCache: { at: number; value: Scheme } | undefined

/** The terminal's light/dark scheme, cached briefly so a repaint does not re-probe. */
async function detectScheme($: EngineInterface): Promise<Scheme> {
  if (schemeCache && Date.now() - schemeCache.at < SCHEME_TTL_MS) return schemeCache.value

  let value: Scheme | undefined
  try {
    // "15;0": the last field is the background's palette index; 0-7 are dark.
    const fgbg = await $.env.get('COLORFGBG')
    const bg = typeof fgbg === 'string' ? Number(fgbg.split(';').at(-1)) : NaN
    if (Number.isFinite(bg)) value = bg < 8 ? 'dark' : 'light'
  } catch {} // no terminal hint
  if (!value) {
    try {
      // macOS: the key is absent in light mode, which `defaults` reports as exit 1.
      const run = await $.process.run(['defaults', 'read', '-g', 'AppleInterfaceStyle'])
      value = run.exitCode === 0 && /dark/i.test(run.stdout) ? 'dark' : 'light'
    } catch {} // no `defaults`: a non-macOS host
  }

  value ??= 'dark'
  schemeCache = { at: Date.now(), value }
  return value
}

export const register: Register = on => {
  on('ui.render', { component: 'AssistantMessage' }, async ($, e, next) => {
    if (e.surface !== 'terminal') return next(e)
    const segments = splitFences(e.props.text)
    if (!segments.some(segment => segment.kind === 'code')) return next(e)
    const scheme = await detectScheme($)

    const { Box, Text } = $.ui.resolve(e)
    const codeBlock = (source: string, lang: Lang, paletteName: PaletteName) => {
      const palette = paletteFor(paletteName, scheme)
      return (
        <Box flexDirection="column" paddingLeft={CODE_INDENT}>
          {toLines(source, lang).map(tokens => (
            <Text>
              {tokens.length === 0
                ? ' '
                : tokens.map(({ kind, text }) => {
                    const color = palette[kind]
                    return color ? <Text color={color}>{text}</Text> : text
                  })}
            </Text>
          ))}
        </Box>
      )
    }

    const children: RenderNode[] = []
    for (const segment of segments) {
      if (segment.kind === 'code') {
        children.push(codeBlock(segment.source, segment.lang, segment.palette ?? DEFAULT_PALETTE))
        continue
      }
      const text = segment.text.trim()
      if (!text) continue
      const isFirstOfReply = e.props.isFirstOfReply && children.length === 0
      children.push(await next({ ...e, props: { ...e.props, text, isFirstOfReply } }))
    }
    return (
      <Box flexDirection="column" rowGap={1}>
        {children}
      </Box>
    )
  }).catch(($, e, next) => next(e))

  // ToolUse, not ToolResult: the engine raises ToolResult only under a standalone
  // tool row, and Edit rows here never got one (seen with a probe on both sites).
  on('ui.render', { component: 'ToolUse' }, async ($, e, next) => {
    if (e.surface !== 'terminal' || e.props.isErrored || !FILE_EDIT_TOOLS.has(e.props.tool)) return next(e)
    const patch = readPatch(e.props.output)
    const lang = patch && langFromPath(patch.filePath)
    if (!patch || !lang) return next(e)

    const { Box, Text } = $.ui.resolve(e)
    const palette = paletteFor('auto', await detectScheme($))
    const rows = diffRows(patch.hunks, lang)
    const gutter = Math.max(...rows.map(row => (row.kind === 'gap' ? 0 : String(row.lineNo).length)))
    // The engine draws the header from an output with no patch; its result row is then left empty.
    const output = { ...(e.props.output as Record<string, unknown>), structuredPatch: [] }
    const engineRow = await next({ ...e, props: { ...e.props, output } })

    const tokenText = (row: Exclude<DiffRow, { kind: 'gap' }>) =>
      row.tokens.map(({ kind, text, isChanged }) => {
        const color = palette[kind]
        const word = isChanged && row.kind !== 'context' ? CHANGED_WORD_TINT[row.kind] : undefined
        if (!color && !word) return text
        return <Text {...(color ? { color } : {})} {...(word ? { backgroundColor: word } : {})}>{text}</Text>
      })
    const line = (row: DiffRow) => {
      if (row.kind === 'gap') return <Text dimColor>{' '.repeat(gutter)} ...</Text>
      const tint = row.kind === 'context' ? undefined : DIFF_TINT[row.kind]
      return (
        <Box flexGrow={1} {...(tint ? { backgroundColor: tint } : {})}>
          <Text>
            <Text dimColor>{`${String(row.lineNo).padStart(gutter)} ${DIFF_SIGN[row.kind]} `}</Text>
            {tokenText(row)}
          </Text>
        </Box>
      )
    }

    return (
      <Box flexDirection="column">
        {engineRow}
        <Box flexDirection="column" paddingLeft={DIFF_INDENT}>
          <Box position="absolute" top={-1} left={SUMMARY_COLUMN}>
            <Text>{summarize(rows).split(/(\d+)/).map(part => (/^\d+$/.test(part) ? <Text bold>{part}</Text> : part))}</Text>
          </Box>
          {rows.map(line)}
        </Box>
      </Box>
    )
  }).catch(($, e, next) => next(e))
}

const FILE_EDIT_TOOLS = new Set(['Edit', 'Write'])

const DIFF_INDENT = 4 // lines up with the engine's result text under the tool row

/** Where the engine wrote "Added 1 line" after the row's corner glyph: the summary is painted over that empty row. */
const SUMMARY_COLUMN = 5

const DIFF_SIGN: Record<'add' | 'remove' | 'context', string> = { add: '+', remove: '-', context: ' ' }
