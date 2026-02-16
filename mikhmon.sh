#!/bin/bash

set -e

INSTALL_DIR="$HOME/mikhmonv3"

echo "--- Lancement de Mikhmon v3 ---"

# ====== Vérifier dossier ======
if [[ ! -d "$INSTALL_DIR" ]]; then
    echo "Erreur : Le dossier $INSTALL_DIR n'existe pas."
    exit 1
fi

cd "$INSTALL_DIR"

# ====== Vérifier PHP ======
if ! command -v php &> /dev/null; then
    echo "Erreur : PHP n'est pas installé."
    exit 1
fi

# ====== Port ======
if command -v lsof &> /dev/null && lsof -Pi :8080 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo "Avertissement : Le port 8080 est déjà utilisé."
    read -p "Voulez-vous utiliser un autre port ? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "Entrez le numéro de port : " PORT
    else
        exit 1
    fi
else
    PORT=8080
fi

URL="http://127.0.0.1:$PORT"

echo "Démarrage du serveur PHP sur $URL"
echo "Appuyez sur Ctrl+C pour arrêter le serveur"
echo "----------------------------------------"

# ====== OUVERTURE NAVIGATEUR ======
(
sleep 2

if command -v termux-open-url &> /dev/null; then
    termux-open-url "$URL"

elif command -v xdg-open &> /dev/null; then
    xdg-open "$URL" > /dev/null 2>&1

else
    echo "Impossible d'ouvrir automatiquement le navigateur."
fi

) &

# ====== Lancer serveur ======
php -S 127.0.0.1:$PORT
