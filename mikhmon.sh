#!/usr/bin/env bash

INSTALL_DIR="$HOME/mikhmonv3"
PORT=8080
URL="http://127.0.0.1:$PORT"

# ===== COULEURS =====
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# ===== BANNIERE =====
banner() {
clear
echo -e "${RED}"
cat << "EOF"
███╗   ███╗██╗██╗  ██╗██╗  ██╗███╗   ███╗ ██████╗ ███╗   ██╗
████╗ ████║██║██║ ██╔╝██║  ██║████╗ ████║██╔═══██╗████╗  ██║
██╔████╔██║██║█████╔╝ ███████║██╔████╔██║██║   ██║██╔██╗ ██║
██║╚██╔╝██║██║██╔═██╗ ██╔══██║██║╚██╔╝██║██║   ██║██║╚██╗██║
██║ ╚═╝ ██║██║██║  ██╗██║  ██║██║ ╚═╝ ██║╚██████╔╝██║ ╚████║
╚═╝     ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝

        F S O C I E T Y   C O N T R O L
EOF
echo -e "${RESET}"
echo -e "${CYAN}by Mr Robot${RESET}"
echo ""
}

# ===== STATUS =====
status_check() {
if command -v lsof &> /dev/null && lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${GREEN}● ONLINE${RESET}"
else
    echo -e "${RED}● OFFLINE${RESET}"
fi
}

# ===== START =====
start_server() {

if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${YELLOW}Serveur déjà actif${RESET}"
    return
fi

cd "$INSTALL_DIR" || exit

php -S 127.0.0.1:$PORT >/dev/null 2>&1 &

sleep 1

echo -e "${GREEN}[✓] Serveur lancé${RESET}"
echo -e "URL → ${CYAN}$URL${RESET}"

if command -v termux-open-url &> /dev/null; then
    termux-open-url "$URL"
elif command -v xdg-open &> /dev/null; then
    xdg-open "$URL" >/dev/null 2>&1
fi
}

# ===== STOP =====
stop_server() {

PID=$(lsof -t -i:$PORT)

if [[ -n "$PID" ]]; then
    kill $PID
    echo -e "${RED}[✗] Serveur arrêté${RESET}"
else
    echo "Serveur déjà arrêté"
fi
}

# ===== MENU =====
menu() {
while true; do
    banner

    echo -n "Status : "
    status_check
    echo ""

    echo -e "${CYAN}1) Démarrer serveur${RESET}"
    echo -e "${CYAN}2) Arrêter serveur${RESET}"
    echo -e "${CYAN}3) Status${RESET}"
    echo -e "${CYAN}4) Ouvrir interface${RESET}"
    echo -e "${RED}0) Quitter${RESET}"
    echo ""

    read -p "fsociety@control >> " choix

    case $choix in

        1) start_server ;;
        2) stop_server ;;
        3) echo ""; status_check; sleep 2 ;;
        4)
            if command -v termux-open-url &> /dev/null; then
                termux-open-url "$URL"
            elif command -v xdg-open &> /dev/null; then
                xdg-open "$URL" >/dev/null 2>&1
            fi
            ;;
        0) exit ;;
        *) echo "Option invalide"; sleep 1 ;;
    esac
done
}

menu
