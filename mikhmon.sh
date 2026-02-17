#!/usr/bin/env bash

set -e

INSTALL_DIR="$HOME/mikhmonv3"
PID_FILE="$INSTALL_DIR/server.pid"
PORT=8080
URL="http://127.0.0.1:$PORT"

# ===== COULEURS =====
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
RESET='\033[0m'

case "$1" in

start)

echo -e "${CYAN}--- Lancement de Mikhmon v3 ---${RESET}"

if [[ ! -d "$INSTALL_DIR" ]]; then
    echo "Erreur : dossier introuvable"
    exit 1
fi

cd "$INSTALL_DIR"

if ! command -v php &> /dev/null; then
    echo "Erreur : PHP non installé"
    exit 1
fi

if [[ -f "$PID_FILE" ]] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
    echo -e "${GREEN}Serveur déjà actif.${RESET}"
    exit 0
fi

php -S 127.0.0.1:$PORT >/dev/null 2>&1 &

echo $! > "$PID_FILE"

echo -e "${GREEN}[ ONLINE ] Serveur lancé${RESET}"
echo "URL : $URL"

sleep 2

if command -v termux-open-url &> /dev/null; then
    termux-open-url "$URL"
elif command -v xdg-open &> /dev/null; then
    xdg-open "$URL" >/dev/null 2>&1
fi

;;

stop)

if [[ -f "$PID_FILE" ]]; then
    PID=$(cat "$PID_FILE")

    if kill -0 $PID 2>/dev/null; then
        kill $PID
        rm "$PID_FILE"
        echo -e "${RED}[ OFFLINE ] Serveur arrêté${RESET}"
    else
        echo "Serveur déjà arrêté"
        rm "$PID_FILE"
    fi
else
    echo "Aucun serveur en cours"
fi

;;

status)

if [[ -f "$PID_FILE" ]] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
    echo -e "${GREEN}[ ONLINE ] Serveur actif${RESET}"
    echo "URL : $URL"
else
    echo -e "${RED}[ OFFLINE ] Serveur arrêté${RESET}"
fi

;;

*)

echo "Usage :"
echo "  $0 start"
echo "  $0 stop"
echo "  $0 status"

;;

esac
