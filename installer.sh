#!/bin/bash
# Exemple de script d'installation automatique
pkg install php curl unzip -y
cd $HOME
git clone https://github.com/Mr-Robot-92/mikhmonv3.git
ln -s $HOME/mikhmonv3/mikhmon.sh $PREFIX/bin/mikhmon
chmod +x $HOME/mikhmonv3/mikhmon.sh
echo "Installation terminée. Tapez 'mikhmon' pour lancer."
