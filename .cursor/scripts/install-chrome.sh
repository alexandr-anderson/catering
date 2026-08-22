#!/usr/bin/env bash
# Idempotent Google Chrome install for Cursor Cloud Agents (computer use / browser automation).
set -euo pipefail

SCRIPT_VERSION="v1.0.0"
VERSION_PATH="/usr/local/bin/catering-chrome.version"
TARGET_USER="${SUDO_USER:-${USER:-ubuntu}}"

run_as_root() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  else
    sudo "$@"
  fi
}

if [ -f "${VERSION_PATH}" ] && [ "$(tr -d '\n\r' < "${VERSION_PATH}")" = "${SCRIPT_VERSION}" ]; then
  echo "Google Chrome already installed (${SCRIPT_VERSION}), skipping"
  exit 0
fi

if ! command -v apt-get >/dev/null 2>&1; then
  echo "ERROR: apt-get is not available; Chrome install requires Debian/Ubuntu" >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

run_as_root apt-get update
run_as_root apt-get install -y --no-install-recommends ca-certificates curl gnupg

run_as_root mkdir -p /etc/apt/keyrings
if [ ! -f /etc/apt/keyrings/google-linux-signing.gpg ]; then
  curl --retry 5 --retry-delay 2 --retry-all-errors -fsSL \
    https://dl.google.com/linux/linux_signing_key.pub | \
    run_as_root gpg --dearmor --batch --yes -o /etc/apt/keyrings/google-linux-signing.gpg
  run_as_root chmod a+r /etc/apt/keyrings/google-linux-signing.gpg
fi

if [ ! -f /etc/apt/sources.list.d/google-chrome.list ]; then
  run_as_root tee /etc/apt/sources.list.d/google-chrome.list >/dev/null <<'EOF'
deb [arch=amd64 signed-by=/etc/apt/keyrings/google-linux-signing.gpg] https://dl.google.com/linux/chrome/deb/ stable main
EOF
fi

run_as_root apt-get update
run_as_root apt-get install -y --no-install-recommends google-chrome-stable

if ! id -u "${TARGET_USER}" >/dev/null 2>&1; then
  echo "ERROR: target user ${TARGET_USER} does not exist" >&2
  exit 1
fi

TARGET_HOME="$(getent passwd "${TARGET_USER}" | cut -d: -f6)"
TARGET_GROUP="$(id -gn "${TARGET_USER}")"
CHROME_PROFILE_DIR="${TARGET_HOME}/.config/google-chrome"
CHROME_FLAGS="--no-sandbox --test-type --disable-dev-shm-usage --use-gl=angle --use-angle=swiftshader-webgl --password-store=basic --no-first-run --no-default-browser-check --remote-debugging-port=9222 --user-data-dir=${CHROME_PROFILE_DIR} --class=google-chrome --window-size=1820,1100 --window-position=50,50"

write_wrapper() {
  local path="$1"
  run_as_root tee "${path}" >/dev/null <<EOF
#!/bin/bash
exec /usr/bin/google-chrome-stable ${CHROME_FLAGS} "\$@"
EOF
  run_as_root chmod 0755 "${path}"
}

write_wrapper /usr/local/bin/google-chrome
write_wrapper /usr/local/bin/chrome

run_as_root mkdir -p "${CHROME_PROFILE_DIR}/Default"
run_as_root chown -R "${TARGET_USER}:${TARGET_GROUP}" "${TARGET_HOME}/.config" 2>/dev/null || true

if ! command -v google-chrome-stable >/dev/null 2>&1; then
  echo "ERROR: google-chrome-stable not found after install" >&2
  exit 1
fi

google-chrome-stable --version
run_as_root mkdir -p "$(dirname "${VERSION_PATH}")"
printf '%s\n' "${SCRIPT_VERSION}" | run_as_root tee "${VERSION_PATH}" >/dev/null

echo "Installed and configured Google Chrome (${SCRIPT_VERSION}) for user ${TARGET_USER}"
