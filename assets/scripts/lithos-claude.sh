#!/usr/bin/env bash
set -euo pipefail

# Run Claude Code against LithosAI models.
#
# Claude Code speaks the Anthropic Messages API and LithosAI serves Chat
# Completions, so this points Claude Code at the local LiteLLM proxy
# (claude/litellm.yaml). A resident proxy is normally installed by
# scripts/enable-litellm-claude.sh; if none is running, this starts a
# throwaway one for the duration of the session.
# Usage: lithos-claude [claude args...]

proxy_port=${LITHOS_PROXY_PORT:-4001}
proxy_url="http://127.0.0.1:$proxy_port"
proxy_key="sk-claude-proxy"
config=${LITHOS_LITELLM_CONFIG:-$HOME/.config/litellm/claude.yaml}
log=${TMPDIR:-/tmp}/litellm-claude.log

if ! command -v claude >/dev/null 2>&1; then
  echo "lithos-claude: claude not found on PATH" >&2
  exit 1
fi

if ! curl -fsS -m 2 "$proxy_url/health/liveliness" >/dev/null 2>&1; then
  if ! command -v litellm >/dev/null 2>&1; then
    echo "lithos-claude: litellm not found; install it with" >&2
    echo "  uv tool install 'litellm[proxy]==1.106.1'" >&2
    exit 1
  fi

  if [ -z "${LITHOSAI_API_KEY-}" ]; then
    echo "lithos-claude: LITHOSAI_API_KEY is not set (e.g. via ~/.env)" >&2
    exit 1
  fi

  litellm --config "$config" --host 127.0.0.1 --port "$proxy_port" >"$log" 2>&1 &
  proxy_pid=$!

  for _ in $(seq 1 600); do
    if curl -fsS -m 1 "$proxy_url/health/liveliness" >/dev/null 2>&1; then
      break
    fi
    if ! kill -0 "$proxy_pid" 2>/dev/null; then
      echo "lithos-claude: proxy exited; see $log" >&2
      exit 1
    fi
    sleep 0.1
  done

  if ! curl -fsS -m 1 "$proxy_url/health/liveliness" >/dev/null 2>&1; then
    echo "lithos-claude: proxy did not start within 60s; see $log" >&2
    exit 1
  fi

  trap 'kill "$proxy_pid" 2>/dev/null || true' EXIT
fi

export ANTHROPIC_BASE_URL="$proxy_url"
export ANTHROPIC_AUTH_TOKEN="$proxy_key"
export ANTHROPIC_MODEL="${ANTHROPIC_MODEL:-deepseek-v4.1-flash}"
export ANTHROPIC_DEFAULT_OPUS_MODEL="${ANTHROPIC_DEFAULT_OPUS_MODEL:-deepseek-v4.1-flash-ultra}"
export ANTHROPIC_DEFAULT_SONNET_MODEL="${ANTHROPIC_DEFAULT_SONNET_MODEL:-deepseek-v4.1-flash}"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="${ANTHROPIC_DEFAULT_HAIKU_MODEL:-deepseek-v4.1-flash-fast}"
export CLAUDE_CODE_MAX_CONTEXT_TOKENS="${CLAUDE_CODE_MAX_CONTEXT_TOKENS:-1048576}"
export CLAUDE_CODE_MAX_OUTPUT_TOKENS="${CLAUDE_CODE_MAX_OUTPUT_TOKENS:-32768}"

claude "$@"
# No exec: the EXIT trap must run to stop a fallback proxy.
