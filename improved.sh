#!/bin/bash

clear

# ====== COULEURS ======
R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
C='\033[1;36m'
W='\033[0m'
B='\033[1;34m'

# ====== FONCTION ANIMATION LOADING ======
loading_spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    echo -n " "
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

loading_dots() {
    local message=$1
    local duration=$2
    echo -n -e "${C}${message}${W}"
    for i in $(seq 1 $duration); do
        echo -n "."
        sleep 0.3
    done
    echo -e " ${G}✓${W}"
}

progress_bar() {
    local duration=$1
    local message=$2
    echo -n -e "${C}${message} ${W}"
    for i in $(seq 1 20); do
        echo -n "█"
        sleep $(echo "scale=2; $duration/20" | bc)
    done
    echo -e " ${G}100%${W}"
}

# ====== BANNIERE ======
echo -e "${R}"
cat << "EOF"
███╗   ███╗██╗██╗  ██╗██╗  ██╗███╗   ███╗ ██████╗ ███╗   ██╗
████╗ ████║██║██║ ██╔╝██║  ██║████╗ ████║██╔═══██╗████╗  ██║
██╔████╔██║██║█████╔╝ ███████║██╔████╔██║██║   ██║██╔██╗ ██║
██║╚██╔╝██║██║██╔═██╗ ██╔══██║██║╚██╔╝██║██║   ██║██║╚██╗██║
██║ ╚═╝ ██║██║██║  ██╗██║  ██║██║ ╚═╝ ██║╚██████╔╝██║ ╚████║
╚═╝     ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝

        M I K H M O N   V 3   I N S T A L L E R
        modded by Mr-Robot
EOF
echo -e "${W}"

# ====== SIGNATURE ======
echo -e "${R}"
cat << "EOF"
        ┌────────────────────────────┐
             by Mr Robot
               F S O C I E T Y
            lafsociety2@gmail.com     
        └────────────────────────────┘
EOF
echo -e "${W}"

loading_dots "[*] Initialisation du système" 3

# ====== MENU ======
echo ""
echo -e "${Y}╔════════════════════════════╗${W}"
echo -e "${Y}║   MENU D'INSTALLATION      ║${W}"
echo -e "${Y}╚════════════════════════════╝${W}"
echo -e "${G}1) Installer Mikhmon V3${W}"
echo -e "${R}2) Quitter${W}"
echo ""

read -p ">>> " choix

if [ "$choix" != "1" ]; then
    echo -e "${R}[✗] Annulé.${W}"
    exit
fi

# ====== DETECTION SYSTEME ======
echo ""
loading_dots "[*] Analyse de l'environnement" 2

if [ -d "/data/data/com.termux" ]; then
    SYS="TERMUX"
else
    SYS="LINUX"
fi

echo -e "${G}[✓] Système détecté : $SYS${W}"
sleep 1

# ====== INSTALL DEPENDANCES ======
echo ""
echo -e "${C}[+] Installation des dépendances...${W}"
progress_bar 2 "[*] Téléchargement des paquets"

if [ "$SYS" = "TERMUX" ]; then
    pkg update -y > /dev/null 2>&1 &
    loading_spinner $!
    echo -e "${G}[✓] Mise à jour terminée${W}"
    
    pkg install php curl unzip git -y > /dev/null 2>&1 &
    loading_spinner $!
    echo -e "${G}[✓] Dépendances installées${W}"
    
    INSTALL_DIR="$HOME"
    BIN_DIR="$PREFIX/bin"
else
    sudo apt update -y > /dev/null 2>&1 &
    loading_spinner $!
    echo -e "${G}[✓] Mise à jour terminée${W}"
    
    sudo apt install php curl unzip git -y > /dev/null 2>&1 &
    loading_spinner $!
    echo -e "${G}[✓] Dépendances installées${W}"
    
    INSTALL_DIR="$HOME"
    BIN_DIR="/usr/local/bin"
fi

# ====== TELECHARGEMENT ======
echo ""
echo -e "${C}[+] Téléchargement de Mikhmon V3...${W}"
cd "$INSTALL_DIR"
rm -rf mikhmonv3 > /dev/null 2>&1

git clone https://github.com/Mr-Robot-92/mikhmonv3.git > /dev/null 2>&1 &
loading_spinner $!
echo -e "${G}[✓] Téléchargement terminé${W}"

# ====== CONFIG ======
echo ""
loading_dots "[*] Configuration de l'application" 3

chmod +x "$INSTALL_DIR/mikhmonv3/mikhmon.sh"

if [ "$SYS" = "TERMUX" ]; then
    ln -sf "$INSTALL_DIR/mikhmonv3/mikhmon.sh" "$BIN_DIR/mikhmon"
else
    sudo ln -sf "$INSTALL_DIR/mikhmonv3/mikhmon.sh" "$BIN_DIR/mikhmon"
fi

echo -e "${G}[✓] Configuration terminée${W}"
sleep 1

# ====== FIN ======
echo ""
echo -e "${G}╔════════════════════════════════════╗${W}"
echo -e "${G}║  ✓ INSTALLATION TERMINÉE !        ║${W}"
echo -e "${G}╚════════════════════════════════════╝${W}"
echo ""
echo -e "${B}[i] Commande pour lancer : ${G}mikhmon${W}"
echo ""

# ====== ANIMATIONS FINALES ======
loading_dots "${R}[*] Connexion au système" 2
echo -e "${G}[✓] Accès autorisé${W}"
sleep 1

# ====== OUVERTURE YOUTUBE ======
echo ""
echo -e "${Y}╔════════════════════════════════════╗${W}"
echo -e "${Y}║   SOUTENEZ LE PROJET !            ║${W}"
echo -e "${Y}╚════════════════════════════════════╝${W}"
echo ""
loading_dots "${C}[*] Ouverture de la chaîne YouTube" 2

# Remplace cette URL par l'URL de ta chaîne YouTube
YOUTUBE_URL="https://youtu.be/G4yCXoH13TY?si=RwatDwVkN9zQaSl_"

if [ "$SYS" = "TERMUX" ]; then
    termux-open-url "$YOUTUBE_URL" 2>/dev/null || {
        echo -e "${Y}[!] Impossible d'ouvrir automatiquement${W}"
        echo -e "${C}[i] Visite manuellement : $YOUTUBE_URL${W}"
    }
else
    if command -v xdg-open > /dev/null; then
        xdg-open "$YOUTUBE_URL" 2>/dev/null &
    elif command -v open > /dev/null; then
        open "$YOUTUBE_URL" 2>/dev/null &
    else
        echo -e "${Y}[!] Impossible d'ouvrir automatiquement${W}"
        echo -e "${C}[i] Visite manuellement : $YOUTUBE_URL${W}"
    fi
fi

sleep 1
echo -e "${G}[✓] N'oublie pas de t'abonner ! 🔔${W}"
echo ""

# ====== SIGNATURE FINALE ======
echo -e "${R}╔════════════════════════════════════╗${W}"
echo -e "${R}║      -- Mr Robot | Fsociety --    ║${W}"
echo -e "${R}║      lafsociety2@gmail.com        ║${W}"
echo -e "${R}╚════════════════════════════════════╝${W}"
echo ""
echo -e "${Y}Lancez maintenant : ${G}mikhmon${W}"
echo ""
