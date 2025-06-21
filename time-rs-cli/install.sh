#!/usr/bin/env bash
set -e

REPO="ryu-ryuk/time-rs-cli"
BIN_NAME="timers"
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

# normalize architecture names
case "$ARCH" in
    x86_64) ARCH="x86_64" ;;
    aarch64|arm64) ARCH="aarch64" ;;
    *) echo "❌ Unsupported architecture: $ARCH"; exit 1 ;;
esac

FILENAME="${BIN_NAME}-${OS}-${ARCH}.tar.gz"

echo "-> Fetching latest release info..."
DOWNLOAD_URL=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" \
  | grep "browser_download_url" \
  | grep "$FILENAME" \
  | cut -d '"' -f 4)

if [ -z "$DOWNLOAD_URL" ]; then
  echo "Uh-Oh! No matching binary found for ${OS}-${ARCH}."
  exit 1
fi

echo "-> Downloading: $FILENAME"
curl -sL "$DOWNLOAD_URL" -o "$FILENAME"

echo "-> Extracting binary..."
tar -xzf "$FILENAME"
rm "$FILENAME"

if [ ! -f "$BIN_NAME" ]; then
  echo " Oh... Extracted binary '$BIN_NAME' not found."
  exit 1
fi

chmod +x "$BIN_NAME"

echo "-> Installing to /usr/local/bin (requires sudo)"
sudo mv "$BIN_NAME" /usr/local/bin/

echo "Wohoo! Installed '$BIN_NAME' to /usr/local/bin"
echo "Run it by typing: timers"

