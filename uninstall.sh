#!/bin/bash

## Project		: Compile Manager
## Description	: Un programma che facilita la compilazione del codice sorgente in diversi linguaggi senza l'utilizzo di alcun IDE
## File			: uninstall.sh
## Author		: Gabriele Princiotta
## Date			: 22/06/2020

# Funzioni per stampare a schermo il testo con diversi colori
shw_green () {
    echo $(tput bold)$(tput setaf 2) $@ $(tput sgr 0)
}

shw_err ()  {
    echo $(tput bold)$(tput setaf 1) $@ $(tput sgr 0)
}

if sudo rm -rf /opt/compileManager/ && sudo rm /usr/share/applications/compileManager.desktop && sudo rm /usr/bin/compileManager; then
	shw_green "Programma disinstallato con successo!"
else
	shw_err "Impossibile disinstallare il programma!"
fi
