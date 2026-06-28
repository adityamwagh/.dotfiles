#!/usr/bin/env bash
set -euo pipefail

# Regenerate the vendored "Iosevka Extended" fonts via Iosevka's official Docker
# build (the docker/ context in the Iosevka repo). This is a manual developer
# tool and is NOT run by ./install -- it rebuilds the .ttf bytes committed under
# fonts/IosevkaExtended/ from that directory's private-build-plans.toml.
#
# Output: all 9 weights, upright only, at Extended width (9 TTF files).
#
# Usage: scripts/build-custom-iosevka-extended.sh [dotfiles_root]
#   IOSEVKA_VERSION env var overrides the pinned source tag.

IOSEVKA_VERSION="${IOSEVKA_VERSION:-v34.7.0}"
image="iosevka-builder"
plan_name="IosevkaExtended"

root_dir="${1:-$HOME/.dotfiles}"
font_dir="$root_dir/fonts/IosevkaExtended"
plan_file="$font_dir/private-build-plans.toml"

if ! command -v docker >/dev/null 2>&1; then
  echo "Error: docker is required to build Iosevka" >&2
  exit 1
fi
if [ ! -f "$plan_file" ]; then
  echo "Error: build plan not found at $plan_file" >&2
  exit 1
fi

tmp_dirs=()
cleanup() {
  [ "${#tmp_dirs[@]}" -gt 0 ] || return 0
  # Best-effort: a cleanup failure must never mask the real exit code. The
  # container writes dist/ as root, so reclaim ownership (via a throwaway root
  # container) before rm if a plain rm is denied.
  for d in "${tmp_dirs[@]}"; do
    [ -d "$d" ] || continue
    rm -rf "$d" 2>/dev/null && continue
    docker run --rm -v "$d:/clean" --entrypoint chown "$image" \
      -R "$(id -u):$(id -g)" /clean >/dev/null 2>&1 || true
    rm -rf "$d" 2>/dev/null || true
  done
}
trap cleanup EXIT

# Build the Docker image once (its build context is just the repo's docker/ dir).
if ! docker image inspect "$image" >/dev/null 2>&1; then
  echo "Building $image image (one-time)..."
  repo_dir="$(mktemp -d)"
  tmp_dirs+=("$repo_dir")
  git clone --depth 1 https://github.com/be5invis/Iosevka.git "$repo_dir" >/dev/null 2>&1
  docker build -t "$image" "$repo_dir/docker"
fi

work="$(mktemp -d)"
tmp_dirs+=("$work")
cp "$plan_file" "$work/private-build-plans.toml"

echo "Building $plan_name from Iosevka $IOSEVKA_VERSION (this takes a while)..."
docker run --rm -e SOURCE="$IOSEVKA_VERSION" -v "$work:/work" "$image" "ttf::$plan_name"

# The container ran as root, so its dist/ output is root-owned. Hand it back to
# the host user so the copy and cleanup below work without elevated privileges.
docker run --rm -v "$work:/work" --entrypoint chown "$image" \
  -R "$(id -u):$(id -g)" /work >/dev/null 2>&1 || true

dist="$work/dist/$plan_name/TTF"
if [ ! -d "$dist" ]; then
  echo "Error: build produced no TTF output at $dist" >&2
  exit 1
fi

# Refresh the vendored fonts: drop the old TTFs, copy the freshly built ones.
mkdir -p "$font_dir"
find "$font_dir" -maxdepth 1 -type f -iname "*.ttf" -delete
cp -f "$dist"/*.ttf "$font_dir"/
count=$(find "$font_dir" -maxdepth 1 -type f -iname "*.ttf" | wc -l)
echo "Regenerated $count TTF files in $font_dir"
