#!/usr/bin/env bash
set -e

# === config ===
REPO="ryu-ryuk/porterm"
BIN_NAME="porterm"
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

# === Catppuccin Mocha colors ===
BOLD=$(tput bold)
RESET=$(tput sgr0)
FG_BLUE="\033[38;2;137;180;250m"
FG_GREEN="\033[38;2;166;227;161m"
FG_RED="\033[38;2;243;139;168m"
FG_YELLOW="\033[38;2;249;226;175m"
FG_LAVENDER="\033[38;2;180;190;254m"
FG_MAUVE="\033[38;2;203;166;247m"

info()    { echo -e "${FG_LAVENDER}${BOLD}»${RESET} ${FG_BLUE}$1${RESET}"; }
error()   { echo -e "${FG_RED}${BOLD}×${RESET} ${FG_RED}$1${RESET}"; exit 1; }
success() { echo -e "${FG_GREEN}${BOLD}✓${RESET} ${FG_GREEN}$1${RESET}"; }
prompt()  { echo -ne "${FG_MAUVE}${BOLD}?${RESET} ${FG_YELLOW}$1${RESET}"; }

# === arch normalize ===
case "$ARCH" in
    x86_64) ARCH="x86_64" ;;
    arm64|aarch64) ARCH="arm64" ;;
    *) error "Unsupported architecture: $ARCH" ;;
esac

# === file name and pattern ===
FILENAME="${BIN_NAME}_${OS^}_${ARCH}.tar.gz"

# === fetching latest release ===
info "Fetching latest release for ${OS}-${ARCH}..."
DOWNLOAD_URL=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" \
  | grep "browser_download_url" \
  | grep "$FILENAME" \
  | cut -d '"' -f 4)

[ -z "$DOWNLOAD_URL" ] && error "No matching binary found for ${FILENAME}."

# === download ===
info "Downloading ${FILENAME}..."
curl -sL "$DOWNLOAD_URL" -o "$FILENAME"

# === extract ===
info "Extracting..."
tar -xzf "$FILENAME"
rm "$FILENAME"

[ ! -f "$BIN_NAME" ] && error "Binary '$BIN_NAME' not found after extraction."
chmod +x "$BIN_NAME"

# === install ===
info "Installing to /usr/local/bin (sudo required)..."
sudo mv "$BIN_NAME" /usr/local/bin/

# === optional ephemeral run ===
prompt "Run 'porterm' once and delete it after? (y/N): "
if ! read -r choice </dev/tty; then
  choice="n"
fi

if [[ "$choice" =~ ^[Yy]$ ]]; then
  info "Running once..."
  porterm
  info "Deleting 'porterm' from /usr/local/bin..."
  sudo rm -f /usr/local/bin/porterm
  success "'porterm' removed after execution"
else
  info "'porterm' remains installed at /usr/local/bin"
  success "'$BIN_NAME' installed to /usr/local/bin"
  info "Run it by typing: ${BOLD}${BIN_NAME}${RESET}"
fi

