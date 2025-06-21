#!/usr/bin/env bash
set -e

BOLD=$(tput bold)
RESET=$(tput sgr0)
FG_MAUVE="\033[38;2;203;166;247m"
FG_SKY="\033[38;2;137;220;235m"
FG_ROSE="\033[38;2;245;194;231m"
FG_LAV="\033[38;2;180;190;254m"

echo -e "${FG_MAUVE}${BOLD}╭──────────────────────────────╮"
echo -e "│       Alok       Ranjan      │"
echo -e "╰──────────────────────────────╯${RESET}"
echo
echo -e "${FG_LAV}Backend Developer · Rust · Python · DevOps${RESET}"
echo
echo -e "${FG_SKY}GitHub:${RESET} https://github.com/ryu-ryuk"
echo -e "${FG_SKY}Pastebin:${RESET} https://paste.alokranjan.me"
echo -e "${FG_SKY}Projects:${RESET} time-rs-cli, yoru, scripts.alokranjan.me"
echo
echo -e "${FG_ROSE}Try a timer:${RESET}"
echo -e "curl -sSL https://scripts.alokranjan.me/time-rs-cli/install.sh | bash"

