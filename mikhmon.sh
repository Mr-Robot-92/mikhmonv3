#!/usr/bin/env bash

set -e

INSTALL_DIR="$HOME/mikhmonv3"
PORT=8080
URL="http://127.0.0.1:$PORT"
PID_FILE="$INSTALL_DIR/mikhmon.pid"

# ===== COULEURS =====
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# ===== LOGO =====
logo() {
clear
echo -e "${CYAN}"
cat << "EOF"
███╗   ███╗██╗██╗  ██╗██╗  ██╗███╗   ███╗ ██████╗ ███╗   ██╗
████╗ ████║██║██║ ██╔╝██║  ██║████╗ ████║██╔═══██╗████╗  ██║
██╔████╔██║██║█████╔╝ ███████║██╔████╔██║██║   ██║██╔██╗ ██║
██║╚██╔╝██║██║██╔═██╗ ██╔══██║██║╚██╔╝██║██║   ██║██║╚██╗██║
██║ ╚═╝ ██║██║██║  ██╗██║  ██║██║ ╚═╝ ██║╚██████╔╝██║ ╚████║
╚═╝     ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝

        M I K H M O N   v3
   MikroTik Hotspot Management Tool
EOF
echo -e "${RESET}"
echo -e "${YELLOW}      Mikhmon v3 Control Script${RESET}"
echo -e "${RED}        modded by Mr Robot — Fsociety${RESET}"
echo ""
}

# ===== CHECK SERVER =====
is_running() {

# Vérifier PID
if [[ -f "$PID_FILE" ]]; then
    PID=$(cat "$PID_FILE")
    if kill -0 "$PID" 2>/dev/null; then
        return 0
    else
        rm -f "$PID_FILE"
    fi
fi

# Vérifier process PHP (Termux safe)
if pgrep -f "php -S 127.0.0.1:$PORT" >/dev/null; then
    return 0
fi

return 1
}

# ===== START =====
start() {

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

if is_running; then
    echo -e "${GREEN}[ ONLINE ] Serveur déjà actif${RESET}"
    echo -e "URL : ${CYAN}$URL${RESET}"
    exit 0
fi

# Nettoyer anciens process fantômes
pkill -f "php -S 127.0.0.1:$PORT" 2>/dev/null || true

cd "$INSTALL_DIR"

php -S 127.0.0.1:$PORT >/dev/null 2>&1 &

echo $! > "$PID_FILE"

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

if is_running; then

    # Tuer via PID si existe
    if [[ -f "$PID_FILE" ]]; then
        kill "$(cat "$PID_FILE")" 2>/dev/null || true
        rm -f "$PID_FILE"
    fi

    # Tuer process PHP
    pkill -f "php -S 127.0.0.1:$PORT" 2>/dev/null || true

    echo -e "${RED}[ OFFLINE ] Serveur arrêté${RESET}"

else
    echo -e "${RED}[ OFFLINE ] Aucun serveur actif${RESET}"
fi
}

# ===== STATUS =====
status() {

logo

if is_running; then
    echo -e "${GREEN}[ ONLINE ] Serveur actif${RESET}"
    echo -e "URL : ${CYAN}$URL${RESET}"
else
    echo -e "${RED}[ OFFLINE ] Serveur arrêté${RESET}"
fi
}

# ===== RESTART =====
restart() {

logo
echo -e "${YELLOW}[ RESTART ] Redémarrage...${RESET}"

stop
sleep 1
start
}

# ===== COMMANDES =====
case "$1" in
    start) start ;;
    stop) stop ;;
    status) status ;;
    restart) restart ;;
    *)
        logo
        echo "Usage :"
        echo "  mikhmon start"
        echo "  mikhmon stop"
        echo "  mikhmon status"
        echo "  mikhmon restart"
    ;;
esac
