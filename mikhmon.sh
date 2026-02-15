#!/bin/bash

# Déterminer le dossier d'installation
# Si on est sur Termux, le chemin contient 'com.termux'
if [[ "$HOME" == *"/com.termux/"* ]]; then
    INSTALL_DIR="$HOME/mikhmonv3"
else
    # Pour Linux PC
    INSTALL_DIR="$HOME/mikhmonv3"
fi

echo "--- Lancement de Mikhmon v3 ---"
cd "$INSTALL_DIR"

# Lancer le serveur PHP sur le port 8080
# Le drapeau -S lance le serveur intégré de PHP
php -S 127.0.0.1:8080
