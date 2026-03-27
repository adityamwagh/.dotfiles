#!/usr/bin/env bash
set -euo pipefail

origin_url="$(git config --get remote.origin.url || true)"
actual_name="$(git config --get user.name || true)"
actual_email="$(git config --get user.email || true)"

if [[ -z "${origin_url}" ]]; then
  echo "[git-identity-guard] remote.origin.url is not set; skipping identity check."
  exit 0
fi

if [[ "${origin_url}" =~ github.com[:/](aditya-neuraco|NeuracoreAI)/ ]]; then
  expected_name="aditya-neuraco"
  expected_email="aditya.wagh@neuracore.com"
else
  expected_name="adityamwagh"
  expected_email="adityamwagh@outlook.com"
fi

if [[ "${actual_name}" != "${expected_name}" || "${actual_email}" != "${expected_email}" ]]; then
  echo "[git-identity-guard] Git identity mismatch for this repo."
  echo "  origin:  ${origin_url}"
  echo "  actual:  ${actual_name} <${actual_email}>"
  echo "  expect:  ${expected_name} <${expected_email}>"
  echo ""
  echo "Fix by running:"
  echo "  git config user.name \"${expected_name}\""
  echo "  git config user.email \"${expected_email}\""
  exit 1
fi

exit 0
