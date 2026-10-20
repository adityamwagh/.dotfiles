/**
 * languages.ts: what each language's tokens are. A rule table per language
 * (tried in order at each position, sticky regexes) and a word classifier that
 * sees the text before and after the word. highlight.ts runs these; the fence
 * tags and file extensions that pick a language live here too.
 */

export type Lang = 'sql' | 'ts' | 'python' | 'rust' | 'hcl'

export type TokenKind = 'keyword' | 'type' | 'name' | 'string' | 'number' | 'comment' | 'function' | 'punct' | 'plain'

export type Token = { kind: TokenKind; text: string; isChanged?: true }

type Rule = { kind: TokenKind | 'word'; pattern: RegExp }

type LanguageSpec = { rules: Rule[]; classifyWord: (word: string, before: string, after: string) => TokenKind }

const words = (list: string) => new Set(list.split(/\s+/))

const isCall = (after: string) => /^\s*\(/.test(after)
const isDefinitionName = (before: string) => /\b(?:fn|def|function)\s+$/.test(before.slice(-12))
const isTypeDefinitionName = (before: string) => /\b(?:class|struct|enum|interface|trait|type)\s+$/.test(before.slice(-16))
const isPascalCase = (word: string) => /^[A-Z]/.test(word)

const NUMBER = /\d[\d_]*(?:\.\d[\d_]*)?(?:[eE][+-]?\d+)?\b/y

const SQL_KEYWORDS = words(
  `select from where and or not null is in as on join left right inner outer full cross group by order having limit offset
   insert into values update set delete create table alter drop add column index unique primary key foreign references
   default constraint check if exists distinct union all case when then else end with returning cascade begin commit
   rollback transaction view trigger asc desc between like true false`,
)
const SQL_TYPES = words(
  `integer int bigint smallint serial bigserial text varchar char boolean bool timestamp timestamptz date time interval
   numeric decimal real float double uuid json jsonb blob bytea`,
)

const TS_KEYWORDS = words(
  `const let var function return if else for while do switch case break continue new delete typeof instanceof in of
   class extends implements interface type enum export import from as async await try catch finally throw yield
   default void this super null undefined true false readonly public private protected static declare keyof satisfies`,
)
const TS_PRIMITIVES = words('string number boolean unknown never any object bigint symbol')

const PYTHON_KEYWORDS = words(
  `def class return if elif else for while in not and or is None True False import from as with try except finally
   raise yield lambda pass break continue global nonlocal async await del assert match case self`,
)
const PYTHON_TYPES = words('int float str bool list dict set tuple bytes object complex frozenset')

const RUST_KEYWORDS = words(
  `fn let mut pub struct enum impl trait use mod crate self super match if else for while loop return as in ref move
   where async await dyn const static type unsafe extern true false break continue`,
)
const RUST_PRIMITIVES = words('i8 i16 i32 i64 i128 isize u8 u16 u32 u64 u128 usize f32 f64 bool char str')

const HCL_KEYWORDS = words(
  `resource data variable output locals module provider terraform backend required_providers dynamic moved import check
   for in if true false null`,
)
const HCL_TYPES = words('string number bool list map set object tuple any')

export const LANGUAGES: Record<Lang, LanguageSpec> = {
  sql: {
    rules: [
      { kind: 'comment', pattern: /--[^\n]*|\/\*[\s\S]*?\*\//y },
      { kind: 'string', pattern: /'(?:[^']|'')*'/y },
      { kind: 'number', pattern: NUMBER },
      { kind: 'word', pattern: /[A-Za-z_][\w$]*/y },
      { kind: 'punct', pattern: /[(),;.*=<>+\-/%]/y },
    ],
    classifyWord: word => {
      const lower = word.toLowerCase()
      if (SQL_TYPES.has(lower)) return 'type'
      return SQL_KEYWORDS.has(lower) ? 'keyword' : 'plain'
    },
  },
  ts: {
    rules: [
      { kind: 'comment', pattern: /\/\/[^\n]*|\/\*[\s\S]*?\*\//y },
      { kind: 'string', pattern: /"(?:[^"\\\n]|\\.)*"|'(?:[^'\\\n]|\\.)*'|`(?:[^`\\]|\\[\s\S])*`/y },
      { kind: 'number', pattern: NUMBER },
      { kind: 'word', pattern: /[A-Za-z_$][\w$]*/y },
      { kind: 'punct', pattern: /[{}()[\];,.:=<>+\-*/%!?&|^~@]/y },
    ],
    classifyWord: (word, before, after) => {
      if (TS_KEYWORDS.has(word)) return 'keyword'
      if (isTypeDefinitionName(before)) return 'name'
      if (TS_PRIMITIVES.has(word) || isPascalCase(word)) return 'type'
      if (/<\/?$/.test(before)) return 'keyword' // a JSX html tag: <div>, </div>
      return isDefinitionName(before) || isCall(after) ? 'function' : 'plain'
    },
  },
  python: {
    rules: [
      { kind: 'comment', pattern: /#[^\n]*/y },
      { kind: 'string', pattern: /[rRbBuUfF]{0,2}(?:"""[\s\S]*?"""|'''[\s\S]*?'''|"(?:[^"\\\n]|\\.)*"|'(?:[^'\\\n]|\\.)*')/y },
      { kind: 'function', pattern: /@[A-Za-z_][\w.]*/y }, // a decorator
      { kind: 'number', pattern: NUMBER },
      { kind: 'word', pattern: /[A-Za-z_]\w*/y },
      { kind: 'punct', pattern: /[{}()[\];,.:=<>+\-*/%!&|^~@]/y },
    ],
    classifyWord: (word, before, after) => {
      if (PYTHON_KEYWORDS.has(word)) return 'keyword'
      if (isTypeDefinitionName(before)) return 'name'
      if (PYTHON_TYPES.has(word) || isPascalCase(word)) return 'type'
      return isDefinitionName(before) || isCall(after) ? 'function' : 'plain'
    },
  },
  rust: {
    rules: [
      { kind: 'comment', pattern: /\/\/[^\n]*|\/\*[\s\S]*?\*\//y },
      { kind: 'string', pattern: /b?"(?:[^"\\]|\\[\s\S])*"|r(#*)"[\s\S]*?"\1/y },
      { kind: 'string', pattern: /'(?:\\.|[^\\'\n])'/y }, // a char
      { kind: 'keyword', pattern: /'[A-Za-z_]\w*/y }, // a lifetime
      { kind: 'number', pattern: /\d[\d_]*(?:\.\d[\d_]*)?(?:[iu](?:8|16|32|64|128|size)|f32|f64)?\b/y },
      { kind: 'word', pattern: /[A-Za-z_]\w*/y },
      { kind: 'punct', pattern: /[{}()[\];,.:=<>+\-*/%!&|^~?#@]/y },
    ],
    classifyWord: (word, before, after) => {
      if (RUST_KEYWORDS.has(word)) return 'keyword'
      if (isTypeDefinitionName(before)) return 'name'
      if (RUST_PRIMITIVES.has(word) || isPascalCase(word)) return 'type'
      if (/^![^=]/.test(after)) return 'function' // a macro: println!, vec!
      return isDefinitionName(before) || isCall(after) ? 'function' : 'plain'
    },
  },
  hcl: {
    rules: [
      { kind: 'comment', pattern: /#[^\n]*|\/\/[^\n]*|\/\*[\s\S]*?\*\//y },
      { kind: 'string', pattern: /"(?:[^"\\\n]|\\.)*"/y },
      { kind: 'number', pattern: NUMBER },
      { kind: 'word', pattern: /[A-Za-z_][\w-]*/y },
      { kind: 'punct', pattern: /[{}()[\],.:=<>+\-*/%!?&|]/y },
    ],
    classifyWord: (word, _before, after) => {
      if (HCL_KEYWORDS.has(word)) return 'keyword'
      if (HCL_TYPES.has(word)) return 'type'
      return isCall(after) ? 'function' : 'plain'
    },
  },
}

/** Fence tags we color; every other fence is left to the engine. */
export const FENCE_LANGS: Record<string, Lang> = {
  sql: 'sql',
  ts: 'ts', typescript: 'ts', tsx: 'ts', js: 'ts', javascript: 'ts', jsx: 'ts', mjs: 'ts', cjs: 'ts',
  py: 'python', python: 'python',
  rs: 'rust', rust: 'rust',
  tf: 'hcl', terraform: 'hcl', hcl: 'hcl', tfvars: 'hcl',
}

const EXTENSION_LANGS: Record<string, Lang> = {
  sql: 'sql',
  ts: 'ts', tsx: 'ts', mts: 'ts', cts: 'ts', js: 'ts', jsx: 'ts', mjs: 'ts', cjs: 'ts',
  py: 'python', pyi: 'python',
  rs: 'rust',
  tf: 'hcl', tfvars: 'hcl', hcl: 'hcl',
}

/** The language a file is colored as, from its extension; `undefined` leaves it to the engine. */
export function langFromPath(path: string): Lang | undefined {
  const match = /\.([A-Za-z]+)$/.exec(path)
  return match?.[1] ? EXTENSION_LANGS[match[1].toLowerCase()] : undefined
}
