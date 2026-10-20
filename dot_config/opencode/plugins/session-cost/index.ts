// Server entrypoint. This plugin is TUI-only (see tui.tsx); it has no
// server-side behavior. The v2 server runtime expects the default export to
// be a definition with an `id` and an `effect` or `setup` function, so we
// export an id plus an empty setup. It must not import "@opencode/plugin",
// which the v2 server runtime does not provide.
export default {
  id: "session-cost",
  setup() {},
}