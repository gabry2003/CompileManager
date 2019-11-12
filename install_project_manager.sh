#! /bin/bash
#title          :install_project_manager.sh
#description    :Con questo script puoi installare il gestore dei progetti
#author         :Gabriele Princiotta
#date           :02-11-2019
#version        :1.0
#Architettura processore
architettura=$(uname -i)
#Installo i software necessari alla compilazione e all'esecuzione dei progetti
#Se sono gia' installati non installera' nulla
echo "Creato da Gabriele Princiotta"
echo "Installazione di Project Manager per Visual Studio Code..."
echo "Ho bisogno dei permessi di amministratore per installare tutti i programmi necessari, dovrai inserire la tua password"
echo "Installazione di build-essential (necessario a compilare per Linux) in corso..."
#Installo build-essential
if sudo apt install build-essential;then
    echo "Installazione di build-essential effettuata con successo!"
else    #Altrimenti
    tput setaf 1; echo "Installazione fallita!"   #Messaggio di errore
    exit    #Fermo lo script
fi
echo "Installazione di MinGW (necessario a compilare per Windows) in corso..."
#Installo MinGW
if sudo apt install mingw-w64;then
    echo "Installazione di MinGW effettuata con successo!"
else    #Altrimenti
    tput setaf 1; echo "Installazione fallita!"   #Messaggio di errore
    exit    #Fermo lo script
fi
echo "Installazione di aptitude (necessario ad installare Wine) in corso..."
#Installo Aptitude
if sudo apt install aptitude;then
    echo "Installazione di aptitude effettuata con successo!"
else    #Altrimenti
    tput setaf 1; echo "Installazione fallita!"   #Messaggio di errore
    exit    #Fermo lo script
fi
echo "Installazione di Wine (necessario ad eseguire i programmi compilati per Windows) in corso..."
sudo dpkg --add-architecture i386
wget -qO- https://dl.winehq.org/wine-builds/Release.key | sudo apt-key add -
sudo apt-add-repository 'deb http://dl.winehq.org/wine-builds/ubuntu/ artful main'
sudo apt update
#Installo Wine
if sudo aptitude install winehq-stable; then
    echo "Installazione di Wine effettuata con successo!"
else    #Altrimenti
    tput setaf 1; echo "Installazione fallita!"   #Messaggio di errore
    exit    #Fermo lo script
fi
echo "Installazione di xTerm in corso..."
#Installo xTerm
if sudo apt install xterm; then
    echo "Installazione di xTerm effettuata con successo!"
else
    tput setaf 1; echo "Installazione fallita!" #Messaggio di errore
    exit    #Fermo lo script
fi
#Se Linuxdeployqt e' installato
if test -f /bin/linuxdeployqt || test -f /usr/bin/linuxdeployqt || test -f /usr/local/bin/linuxdeployqt || test -f /sbin/linuxdeployqt || test -f /usr/sbin/linuxdeployqt || test -f /usr/local/sbin/linuxdeployqt; then    #Se linuxdeployqt e' gia' installato
    echo "Linuxdeployqt e' gia' installato!"
else    #Altrimenti
    echo "Installazione di Linuxdeployqt in corso..."
    #Lo scarico, lo rinomino e lo sposto su /usr/bin/
    if wget https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage && sudo mv linuxdeployqt-continuous-x86_64.AppImage /usr/bin/linuxdeployqt; then   #Se lo ha installato
        echo "Linuxdeployqt installato con successo!"
    else    #Altrimenti
        echo "Impossibile scaricare Linuxdeployqt! E' necessario per creare AppImage di progetti QT ma l'installazione puo' comunque continuare senza utilizzare al momento questa funzione!"
    fi
fi
#Se appimagetool e' installato
if test -f /bin/appimagetool || test -f /usr/bin/appimagetool || test -f /usr/local/bin/appimagetool || test -f /sbin/appimagetool || test -f /usr/sbin/appimagetool || test -f /usr/local/sbin/linuxdappimagetooleployqt; then    #Se appimagetool e' gia' installato
    echo "Appimagetool e' gia' installato!"
else    #Altrimenti
    echo "Installazione di Appimagetool in corso..."
    #Lo scarico, lo rinomino e lo sposto su /usr/bin/
    if [ "$architettura" == "x86_64" ]; then    #Se il computer e' a 64 bit
        if wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-aarch64.AppImage && sudo mv appimagetool-aarch64.AppImage /usr/bin/appimagetool; then   #Se lo ha installato
            echo "Appimagetool installato con successo!"
        else    #Altrimenti
            echo "Impossibile scaricare Appimagetool! E' necessario per creare AppImage di progetti QT ma l'installazione puo' comunque continuare senza utilizzare al momento questa funzione!"
        fi
    else    #Altrimenti
        if wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-i686.AppImage && sudo mv aappimagetool-i686.AppImage /usr/bin/appimagetool; then   #Se lo ha installato
            echo "Appimagetool installato con successo!"
        else    #Altrimenti
            echo "Impossibile scaricare Appimagetool! E' necessario per creare AppImage di progetti QT ma l'installazione puo' comunque continuare senza utilizzare al momento questa funzione!"
        fi
    fi
fi
#Li copio nella cartelle /usr/share/
#Copio compile.sh
if sudo cp compile.sh /usr/share/compile.sh; then   #Se si puo' copiare
    echo "'compile.sh' copiato in /usr/share/"
else    #Altrimenti
    tput setaf 1; echo "Impossibile copiare 'compile.sh' in /usr/share/ !"    #Messaggio di errore
    exit    #Fermo lo script
fi
#Copio new_project.sh
if sudo cp new_project.sh /usr/share/new_project.sh; then   #Se si puo' copiare
    echo "'new_project.sh' copiato in /usr/share/"
else    #Altrimenti
    tput setaf 1; echo "Impossibile copiare 'new_project.sh' in /usr/share/ !"    #Messaggio di errore
    exit    #Fermo lo script
fi
#Copio create_app_image.sh
if sudo cp create_app_image.sh /usr/share/create_app_image.sh; then   #Se si puo' copiare
    echo "'create_app_image.sh' copiato in /usr/share/"
else    #Altrimenti
    tput setaf 1; echo "Impossibile copiare 'create_app_image.sh' in /usr/share/ !"    #Messaggio di errore
    exit    #Fermo lo script
fi
#Gli imposto i permessi di esecuzione
if sudo chmod a+x /usr/share/compile.sh /usr/share/new_project.sh /usr/share/create_app_image.sh; then #Se gli cambia i permessi
    echo "Permessi di esecuzione cambiati con successo!"
else
    tput setaf 1; echo "Impossibile cambiare i permessi di esecuzione!"   #Messaggio di errore
    exit    #Fermo lo script
fi
#Copio new_project.AppImage
if sudo cp new_project.AppImage /usr/bin/new_project.AppImage; then #Se si puo' copiare
    echo "File new_project.AppImage copiato con successo!"
else
    tput setaf 1; echo "Impossibile copiare il file new_project.AppImage!"    #Messaggio di errore
    exit    #Fermo lo script
fi
#Gli imposto i permessi di esecuzione
if sudo chmod a+x /usr/bin/new_project.AppImage; then #Se gli cambia i permessi
    echo "Permessi di esecuzione cambiati con successo!"
else
    tput setaf 1; echo "Impossibile cambiare i permessi di esecuzione!"   #Messaggio di errore
    exit    #Fermo lo script
fi
#Chiedo all'utente la cartella dello Workspace
echo "Inserisci la cartella dello Workspace (ad ESEMPIO "$HOME"/Software/):"
read cartella_workspace #Prendo in input la cartella dello Workspace
#Copio il file tasks.json nel Workspace
if ! test -d $cartella_workspace/.vscode/; then #Se la cartella .vscode non esiste
    mkdir $cartella_workspace/.vscode/  #La creo
fi
if cp tasks.json $cartella_workspace/.vscode/tasks.json; then    #Se lo ho copiato
    tput setaf 2; echo "File 'tasks.json' copiato con successo!"
    tput setaf 2; echo "Installazione completata!"
else    #Altrimenti
    tput setaf 1; echo "Impossibile copiare il file 'tasks.json'!"
    tput setaf 1; echo "Installazione incompleta!"
    exit    #Fermo lo script
fi
