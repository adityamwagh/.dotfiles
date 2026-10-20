// Session cost in the status line.
//
// OpenCode 2.0.24 drops `cost.cache_read` when converting opencode.json
// provider models into runtime cost tiers, and per-message costs recorded
// before pricing was configured stay at 0. So for lithosai models this
// plugin computes the true session cost from the session's live token
// totals and LithosAI's published rates (per 1M tokens, USD). For any
// other provider it falls back to OpenCode's own session cost.
//
// Rates source: https://www.lithosai.com/pricing (Base / Fast / Ultra tiers).
// Reasoning tokens are billed as output tokens; cache_write is 0 because
// LithosAI bills prompt caching on read only.
import { Plugin } from "@opencode/plugin/tui"

// [input, output, cache_read] per 1M tokens.
const RATES: Record<string, [number, number, number]> = {
  "deepseek-ai/DeepSeek-V4.1-Flash": [0.15, 0.6, 0.003],
  "deepseek-ai/DeepSeek-V4.1-Flash-fast": [0.25, 1.0, 0.005],
  "deepseek-ai/DeepSeek-V4.1-Flash-ultra": [0.35, 1.4, 0.007],
  "deepseek-ai/DeepSeek-V4.1-Flash-ultra-chat": [0.35, 1.4, 0.007],
  "zai-org/GLM-5.3": [1.05, 3.3, 0.195],
  "zai-org/GLM-5.3-ultra-chat": [1.05, 3.3, 0.195],
  "zai-org/GLM-5.3-Flash": [0.15, 0.5, 0.03],
  "zai-org/GLM-5.3-Flash-ultra": [0.15, 0.5, 0.03],
  "zai-org/GLM-5.3-Flash-ultra-chat": [0.15, 0.5, 0.03],
  "moonshotai/Kimi-K3": [2.4, 12.0, 0.24],
  "moonshotai/Kimi-K3-fast": [4.0, 20.0, 0.4],
  "moonshotai/Kimi-K3-ultra": [5.6, 28.0, 0.56],
  "moonshotai/Kimi-K3-ultra-chat": [5.6, 28.0, 0.56],
}

function lithosCost(modelID: string, tokens: Record<string, any> | undefined): number | null {
  const rates = RATES[modelID]
  if (!rates || !tokens) return null
  const [input, output, cacheRead] = rates
  const cache = tokens.cache ?? {}
  const usd =
    (tokens.input * input + (tokens.output + tokens.reasoning) * output + (cache.read ?? 0) * cacheRead) / 1e6
  return Number.isFinite(usd) ? usd : null
}

function formatCost(usd: number): string {
  return usd >= 1 ? `$${usd.toFixed(2)}` : `$${usd.toFixed(4)}`
}

export default Plugin.define({
  id: "session-cost",
  setup(context) {
    const segment = (sessionID: unknown) => {
      if (typeof sessionID !== "string" || sessionID.length === 0) return null
      const session = context.data.session.get(sessionID)
      if (!session) return null
      const modelID = session.model?.id
      const usd =
        (modelID && RATES[modelID] && session.model?.providerID === "lithosai"
          ? lithosCost(modelID, session.tokens)
          : undefined) ??
        (typeof context.data.session.cost(sessionID) === "number"
          ? (context.data.session.cost(sessionID) as number)
          : null)
      if (usd === null) return null
      return <text fg={context.theme?.text?.muted}>{formatCost(usd)}</text>
    }

    // In-session: composer footer status segment.
    context.ui.slot({
      append: "prompt.footer.status",
      render: (props: { sessionID?: string } | undefined) => segment(props?.sessionID),
    })

    // Home screen: session-list footer status segment.
    context.ui.slot({
      append: "home.footer.status",
      render: (props: { sessionID?: string } | undefined) => segment(props?.sessionID),
    })
  },
})
