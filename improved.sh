#!/bin/bash

clear

# ====== COULEURS ======
R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
C='\033[1;36m'
W='\033[0m'
B='\033[1;34m'
M='\033[1;35m'

# ====== ANIMATIONS AVANCÉES ======

loading_spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
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

progress_bar() {
    local message=$1
    local total=30
    echo -n -e "${C}${message}${W} ["
    for i in $(seq 1 $total); do
        if [ $i -lt 10 ]; then
            echo -n -e "${R}▓${W}"
        elif [ $i -lt 20 ]; then
            echo -n -e "${Y}▓${W}"
        else
            echo -n -e "${G}▓${W}"
        fi
        sleep 0.05
    done
    echo -e "] ${G}✓${W}"
}

matrix_loading() {
    local message=$1
    local chars="01"
    echo -n -e "${G}${message}${W} "
    for i in $(seq 1 25); do
        echo -n "${chars:RANDOM%${#chars}:1}"
        sleep 0.04
    done
    echo -e " ${G}✓${W}"
}

pulse_effect() {
    for i in {1..3}; do
        echo -n -e "${M}●${W}"
        sleep 0.15
        printf "\b \b"
        echo -n -e "${M}◉${W}"
        sleep 0.15
        printf "\b \b"
        echo -n -e "${M}◎${W}"
        sleep 0.15
        printf "\b \b"
    done
}

typing_effect() {
    local text=$1
    local color=$2
    for (( i=0; i<${#text}; i++ )); do
        echo -n -e "${color}${text:$i:1}${W}"
        sleep 0.03
    done
    echo ""
}

# ====== BANNIERE ANIMÉE ======
echo -e "${R}"
cat << "EOF"
███╗   ███╗██╗██╗  ██╗██╗  ██╗███╗   ███╗ ██████╗ ███╗   ██╗
████╗ ████║██║██║ ██╔╝██║  ██║████╗ ████║██╔═══██╗████╗  ██║
██╔████╔██║██║█████╔╝ ███████║██╔████╔██║██║   ██║██╔██╗ ██║
██║╚██╔╝██║██║██╔═██╗ ██╔══██║██║╚██╔╝██║██║   ██║██║╚██╗██║
██║ ╚═╝ ██║██║██║  ██╗██║  ██║██║ ╚═╝ ██║╚██████╔╝██║ ╚████║
╚═╝     ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
EOF
echo -e "${W}"

typing_effect "        M I K H M O N   V 3   I N S T A L L E R" "${C}"
typing_effect "                  modded by Mr-Robot" "${Y}"

sleep 0.5

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

echo -n -e "${C}[*] Initialisation du système${W} "
pulse_effect
echo -e "${G}✓${W}"

sleep 0.5

# ====== MENU STYLISÉ ======
echo ""
echo -e "${Y}╔════════════════════════════════════╗${W}"
echo -e "${Y}║      MENU D'INSTALLATION           ║${W}"
echo -e "${Y}╠════════════════════════════════════╣${W}"
echo -e "${Y}║                                    ║${W}"
echo -e "${Y}║  ${G}1)${W} Installer Mikhmon V3          ${Y}║${W}"
echo -e "${Y}║  ${R}2)${W} Quitter                       ${Y}║${W}"
echo -e "${Y}║                                    ║${W}"
echo -e "${Y}╚════════════════════════════════════╝${W}"
echo ""

read -p "$(echo -e ${C}[${G}✓${C}]${W}) Votre choix >>> " choix

if [ "$choix" != "1" ]; then
    echo ""
    matrix_loading "[*] Fermeture du programme"
    echo -e "${R}[✗] Installation annulée.${W}"
    exit
fi

# ====== DETECTION SYSTEME ======
echo ""
echo -e "${B}╔════════════════════════════════════╗${W}"
echo -e "${B}║  ANALYSE DE L'ENVIRONNEMENT       ║${W}"
echo -e "${B}╚════════════════════════════════════╝${W}"

sleep 0.5

echo -n -e "${C}[*] Détection du système${W}"
sleep 1 &
loading_spinner $!
echo -e " ${G}✓${W}"

if [ -d "/data/data/com.termux" ]; then
    SYS="TERMUX"
else
    SYS="LINUX"
fi

echo -e "${G}[✓] Système identifié : ${Y}$SYS${W}"
sleep 1

# ====== INSTALL DEPENDANCES ======
echo ""
echo -e "${B}╔════════════════════════════════════╗${W}"
echo -e "${B}║  INSTALLATION DES DÉPENDANCES     ║${W}"
echo -e "${B}╚════════════════════════════════════╝${W}"
echo ""

if [ "$SYS" = "TERMUX" ]; then
    echo -e "${C}[*] Mise à jour des paquets...${W}"
    pkg update -y > /dev/null 2>&1 &
    loading_spinner $!
    echo -e "${G}[✓] Mise à jour terminée${W}"
    echo ""
    
    progress_bar "[*] Installation PHP, Curl, Git"
    pkg install php curl unzip git -y > /dev/null 2>&1
    echo -e "${G}[✓] Dépendances installées avec succès${W}"
    
    INSTALL_DIR="$HOME"
    BIN_DIR="$PREFIX/bin"
else
    echo -e "${C}[*] Mise à jour des paquets...${W}"
    sudo apt update -y > /dev/null 2>&1 &
    loading_spinner $!
    echo -e "${G}[✓] Mise à jour terminée${W}"
    echo ""
    
    progress_bar "[*] Installation PHP, Curl, Git"
    sudo apt install php curl unzip git -y > /dev/null 2>&1
    echo -e "${G}[✓] Dépendances installées avec succès${W}"
    
    INSTALL_DIR="$HOME"
    BIN_DIR="/usr/local/bin"
fi

# ====== TELECHARGEMENT ======
echo ""
echo -e "${B}╔════════════════════════════════════╗${W}"
echo -e "${B}║  TÉLÉCHARGEMENT DE MIKHMON V3     ║${W}"
echo -e "${B}╚════════════════════════════════════╝${W}"
echo ""

cd "$INSTALL_DIR"
rm -rf mikhmonv3 > /dev/null 2>&1

echo -e "${C}[*] Clonage du repository GitHub...${W}"
git clone https://github.com/Mr-Robot-92/mikhmonv3.git > /dev/null 2>&1 &
loading_spinner $!
echo -e "${G}[✓] Téléchargement réussi${W}"

# ====== CONFIGURATION ======
echo ""
echo -e "${B}╔════════════════════════════════════╗${W}"
echo -e "${B}║  CONFIGURATION DE L'APPLICATION   ║${W}"
echo -e "${B}╚════════════════════════════════════╝${W}"
echo ""

matrix_loading "[*] Configuration des permissions"

chmod +x "$INSTALL_DIR/mikhmonv3/mikhmon.sh"

if [ "$SYS" = "TERMUX" ]; then
    ln -sf "$INSTALL_DIR/mikhmonv3/mikhmon.sh" "$BIN_DIR/mikhmon"
else
    sudo ln -sf "$INSTALL_DIR/mikhmonv3/mikhmon.sh" "$BIN_DIR/mikhmon"
fi

echo -e "${G}[✓] Configuration terminée${W}"
sleep 1

# ====== CONNEXION SIMULÉE ======
echo ""
echo -e "${M}╔════════════════════════════════════╗${W}"
echo -e "${M}║  CONNEXION AU SYSTÈME             ║${W}"
echo -e "${M}╚════════════════════════════════════╝${W}"
echo ""

matrix_loading "[*] Authentification"
sleep 0.5
matrix_loading "[*] Vérification des accès"
sleep 0.5
echo -e "${G}[✓] Accès accordé - Bienvenue Mr Robot${W}"
sleep 1

# ====== SUCCESS SCREEN ======
clear
echo -e "${G}"
cat << "EOF"
    ╔═══════════════════════════════════════╗
    ║                                       ║
    ║         ✓  INSTALLATION               ║
    ║            TERMINÉE !                 ║
    ║                                       ║
    ╚═══════════════════════════════════════╝
EOF
echo -e "${W}"

echo -e "${B}[i] Commande d'accès : ${G}mikhmon${W}"
echo ""

# ====== OUVERTURE YOUTUBE ANIMÉE ======
echo -e "${Y}╔════════════════════════════════════╗${W}"
echo -e "${Y}║   SOUTENEZ LE PROJET ! 🔔         ║${W}"
echo -e "${Y}╚════════════════════════════════════╝${W}"
echo ""

# ⚠️ CHANGE CETTE URL PAR TON LIEN YOUTUBE ⚠️
YOUTUBE_URL="https://youtube.com/@ton_nom_de_chaine"

matrix_loading "[*] Ouverture de la chaîne YouTube"

if [ "$SYS" = "TERMUX" ]; then
    if termux-open-url "$YOUTUBE_URL" 2>/dev/null; then
        echo -e "${G}[✓] Chaîne YouTube ouverte${W}"
    else
        echo -e "${Y}[!] Ouverture manuelle requise${W}"
        echo -e "${C}[i] Lien : $YOUTUBE_URL${W}"
    fi
else
    if command -v xdg-open > /dev/null; then
        xdg-open "$YOUTUBE_URL" 2>/dev/null &
        echo -e "${G}[✓] Chaîne YouTube ouverte${W}"
    elif command -v open > /dev/null; then
        open "$YOUTUBE_URL" 2>/dev/null &
        echo -e "${G}[✓] Chaîne YouTube ouverte${W}"
    else
        echo -e "${Y}[!] Ouverture manuelle requise${W}"
        echo -e "${C}[i] Lien : $YOUTUBE_URL${W}"
    fi
fi

sleep 1

echo ""
echo -e "${R}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${W}"
echo -e "${R}  👤 Créé par : Mr Robot${W}"
echo -e "${R}  🏴 Groupe   : Fsociety${W}"
echo -e "${R}  📧 Contact  : lafsociety2@gmail.com${W}"
echo -e "${R}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${W}"
echo ""
echo -e "${Y}💡 Astuce : Lance l'application avec ${G}mikhmon${W}"
echo ""

# Animation finale
echo -n -e "${C}Merci d'avoir installé Mikhmon V3 ! ${W}"
pulse_effect
echo ""
