#!/bin/bash

set -e

INSTALL_DIR="$HOME/mikhmonv3"
PID_FILE="$INSTALL_DIR/server.pid"
PORT=8080
URL="http://127.0.0.1:$PORT"

case "$1" in

start)

echo "--- Lancement de Mikhmon v3 ---"

# Vérifier dossier
if [[ ! -d "$INSTALL_DIR" ]]; then
    echo "Erreur : dossier introuvable"
    exit 1
fi

cd "$INSTALL_DIR"

# Vérifier PHP
if ! command -v php &> /dev/null; then
    echo "Erreur : PHP non installé"
    exit 1
fi

# Vérifier si déjà lancé
if [[ -f "$PID_FILE" ]] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
    echo "Serveur déjà en cours."
    exit 0
fi

# Lancer serveur silencieux
php -S 127.0.0.1:$PORT >/dev/null 2>&1 &

echo $! > "$PID_FILE"

echo "[ OK ] Serveur lancé"
echo "URL : $URL"

# Ouvrir navigateur auto
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
        echo "[ OK ] Serveur arrêté proprement"
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
    echo "[ ONLINE ] Serveur actif"
    echo "URL : $URL"
else
    echo "[ OFFLINE ] Serveur arrêté"
fi

;;

*)

echo "Usage :"
echo "  $0 start   -> démarrer"
echo "  $0 stop    -> arrêter"
echo "  $0 status  -> état"

;;

esac
