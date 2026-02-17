#!/usr/bin/env bash

set -e

INSTALL_DIR="$HOME/mikhmonv3"
PORT=8080
URL="http://127.0.0.1:$PORT"

# ===== COULEURS =====
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# ===== LOGO MIKROTIK =====
logo() {

echo -e "${CYAN}"
cat << "EOF"
 __  __ _ _              _   _ _    
|  \/  (_) | _____ _ __ | |_(_) | __
| |\/| | | |/ / _ \ '_ \| __| | |/ /
| |  | | |   <  __/ | | | |_| |   < 
|_|  |_|_|_|\_\___|_| |_|\__|_|_|\_\
        RouterOS • Hotspot • ISP Tool
EOF
echo -e "${RESET}"

echo -e "${YELLOW}       Mikhmon v3 Control Script${RESET}"
echo -e "${RED}        modded by Mr Robot — Fsociety${RESET}"
echo ""
}

# ===== START =====
start() {

clear
logo

echo -e "${CYAN}--- Lancement de Mikhmon v3 ---${RESET}"

if [[ ! -d "$INSTALL_DIR" ]]; then
    echo "Erreur : dossier introuvable"
    exit 1
fi

if ! command -v php &> /dev/null; then
    echo "Erreur : PHP non installé"
    exit 1
fi

# Vérifier si déjà lancé
if command -v lsof &> /dev/null && lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${GREEN}[ ONLINE ] Serveur déjà actif${RESET}"
    exit 0
fi

cd "$INSTALL_DIR"

php -S 127.0.0.1:$PORT >/dev/null 2>&1 &

sleep 1

echo -e "${GREEN}[ ONLINE ] Serveur lancé${RESET}"
echo -e "URL : ${CYAN}$URL${RESET}"

# Ouvrir navigateur
if command -v termux-open-url &> /dev/null; then
    termux-open-url "$URL"
elif command -v xdg-open &> /dev/null; then
    xdg-open "$URL" >/dev/null 2>&1
fi
}

# ===== STOP =====
stop() {

logo

PID=$(lsof -t -i:$PORT)

if [[ -n "$PID" ]]; then
    kill $PID
    echo -e "${RED}[ OFFLINE ] Serveur arrêté${RESET}"
else
    echo -e "${RED}[ OFFLINE ] Aucun serveur actif${RESET}"
fi
}

# ===== STATUS =====
status() {

logo

if command -v lsof &> /dev/null && lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${GREEN}[ ONLINE ] Serveur actif${RESET}"
    echo -e "URL : ${CYAN}$URL${RESET}"
else
    echo -e "${RED}[ OFFLINE ] Serveur arrêté${RESET}"
fi
}

# ===== COMMANDES =====
case "$1" in
    start) start ;;
    stop) stop ;;
    status) status ;;
    *)
        logo
        echo "Usage :"
        echo "  mikhmon start"
        echo "  mikhmon stop"
        echo "  mikhmon status"
    ;;
esac
