#!/usr/bin/env bash
set -e

# === Config ===
REPO="ryu-ryuk/time-rs-cli"
BIN_NAME="timers"
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

# === Style ===
BOLD=$(tput bold)
RESET=$(tput sgr0)
FG_ROSEWATER="\033[38;2;245;224;220m"
FG_LAVENDER="\033[38;2;180;190;254m"
FG_MAUVE="\033[38;2;203;166;247m"
FG_GREEN="\033[38;2;166;227;161m"
FG_RED="\033[38;2;243;139;168m"
FG_SKY="\033[38;2;137;220;235m"

info()    { echo -e "${FG_LAVENDER}${BOLD}»${RESET} ${FG_SKY}$1${RESET}"; }
error()   { echo -e "${FG_RED}${BOLD}×${RESET} ${FG_RED}$1${RESET}"; exit 1; }
success() { echo -e "${FG_GREEN}${BOLD}✓${RESET} ${FG_GREEN}$1${RESET}"; }

# === Arch Normalize ===
case "$ARCH" in
    x86_64) ARCH="x86_64" ;;
    arm64|aarch64) ARCH="aarch64" ;;
    *) error "Unsupported architecture: $ARCH" ;;
esac

FILENAME="${BIN_NAME}-${OS}-${ARCH}.tar.gz"

# === Fetch latest release ===
info "Fetching latest release for ${OS}-${ARCH}..."
DOWNLOAD_URL=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" \
  | grep "browser_download_url" \
  | grep "$FILENAME" \
  | cut -d '"' -f 4)

[ -z "$DOWNLOAD_URL" ] && error "No matching binary found."

# === Download ===
info "Downloading ${FILENAME}..."
curl -sL "$DOWNLOAD_URL" -o "$FILENAME"

# === Extract ===
info "Extracting..."
tar -xzf "$FILENAME"
rm "$FILENAME"

[ ! -f "$BIN_NAME" ] && error "Binary '$BIN_NAME' not found after extraction."

chmod +x "$BIN_NAME"

# === Install ===
info "Installing to /usr/local/bin (sudo required)..."
sudo mv "$BIN_NAME" /usr/local/bin/

success "'$BIN_NAME' installed to /usr/local/bin"
info "Run it by typing: ${BOLD}${BIN_NAME}${RESET}"

