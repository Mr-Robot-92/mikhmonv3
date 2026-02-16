#!/bin/bash

clear
set -e

# ====== COULEURS ======
R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
C='\033[1;36m'
W='\033[0m'

# ====== SPINNER ======
spinner() {
    local pid=$!
    local spin='-\|/'
    local i=0
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r${C}[ SYSTEM ] Chargement... ${spin:$i:1}${W}"
        sleep .08
    done
    printf "\r${G}[✓] Terminé.${W}\n"
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

        M I K H M O N   V 3   U L T I M A T E
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

sleep 1
echo -e "${C}[ SYSTEM ] Initialisation...${W}"
sleep 1

# ====== DETECTION SYSTEME ======
if [ -d "/data/data/com.termux" ]; then
    SYS="TERMUX"
else
    SYS="LINUX"
fi

echo -e "${G}[✓] Système détecté : $SYS${W}"

# ====== INSTALL DEPENDANCES ======
echo -e "${C}[+] Installation des dépendances...${W}"

if [ "$SYS" = "TERMUX" ]; then
    pkg update -y > /dev/null 2>&1 & spinner
    pkg install php curl unzip git -y > /dev/null 2>&1 & spinner
    INSTALL_DIR="$HOME"
    BIN_DIR="$PREFIX/bin"
else
    sudo apt update -y > /dev/null 2>&1 & spinner
    sudo apt install php curl unzip git -y > /dev/null 2>&1 & spinner
    INSTALL_DIR="$HOME"
    BIN_DIR="/usr/local/bin"
fi

# ====== TELECHARGEMENT ======
echo -e "${C}[+] Téléchargement de Mikhmon...${W}"

cd "$INSTALL_DIR"
rm -rf mikhmonv3 > /dev/null 2>&1
git clone https://github.com/Mr-Robot-92/mikhmonv3.git > /dev/null 2>&1 & spinner

# ====== CONFIG ======
echo -e "${C}[+] Configuration...${W}"

chmod +x "$INSTALL_DIR/mikhmonv3/mikhmon.sh"

if [ "$SYS" = "TERMUX" ]; then
    ln -sf "$INSTALL_DIR/mikhmonv3/mikhmon.sh" "$BIN_DIR/mikhmon"
else
    sudo ln -sf "$INSTALL_DIR/mikhmonv3/mikhmon.sh" "$BIN_DIR/mikhmon"
fi

sleep 1

# ====== INSTALL OK ======
echo ""
echo -e "${G}[✓] INSTALLATION TERMINÉE${W}"
echo -e "${G}[✓] Commande disponible : mikhmon${W}"
echo ""

echo -e "${R}Connexion au système...${W}"
sleep 1
echo -e "${C}Accès autorisé.${W}"
sleep 1

# ====== LANCEMENT AUTO ======
echo -e "${Y}Lancement de Mikhmon...${W}"
sleep 1

cd "$INSTALL_DIR/mikhmonv3"
php -S 127.0.0.1:8080 > /dev/null 2>&1 &

sleep 2

# ====== OUVERTURE NAVIGATEUR ======
URL="http://127.0.0.1:8080"

echo -e "${C}Ouverture de l'interface...${W}"

if [ "$SYS" = "TERMUX" ]; then
    termux-open-url "$URL"
else
    xdg-open "$URL" > /dev/null 2>&1
fi

# ====== PROMO YOUTUBE ======
echo ""
echo -e "${R}Rejoignez la Fsociety...${W}"
sleep 1
echo -e "${C}Abonnez-vous pour plus d’outils exclusifs.${W}"
sleep 2

YT="https://youtube.com/@TON_LIEN"

echo -e "${Y}Ouverture de la chaîne YouTube...${W}"

if [ "$SYS" = "TERMUX" ]; then
    termux-open-url "$YT"
else
    xdg-open "$YT" > /dev/null 2>&1
fi

echo ""
echo -e "${R}-- Mr Robot | Fsociety --${W}"
