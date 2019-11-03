#! /bin/bash
#title          :install_project_manager.sh
#description    :Con questo script puoi installare il gestore dei progetti
#author         :Gabriele Princiotta
#date           :02-11-2019
#version        :1.0
#Installo i software necessari alla compilazione e all'esecuzione dei progetti
#Se sono gia' installati non installera' nulla
echo "Creato da Gabriele Princiotta"
echo "Installazione di Project Manager per Visual Studio Manager..."
echo "Ho bisogno dei permessi di amministratore per installare tutti i programmi, dovrai inserire la tua password"
echo "Installazione di build-essential (necessario a compilare per Linux) in corso..."
if sudo apt install build-essential;then
    echo "Installazione di build-essential effettuata con successo!"
else    #Altrimenti
    echo "Installazione fallita!"   #Messaggio di errore
    exit    #Fermo lo script
fi
echo "Installazione di MinGW (necessario a compilare per Windows) in corso..."
if sudo apt install mingw-w64;then
    echo "Installazione di MinGW effettuata con successo!"
else    #Altrimenti
    echo "Installazione fallita!"   #Messaggio di errore
    exit    #Fermo lo script
fi
echo "Installazione di aptitude (necessario ad installare Wine) in corso..."
if sudo apt install aptitude;then
    echo "Installazione di aptitude effettuata con successo!"
else    #Altrimenti
    echo "Installazione fallita!"   #Messaggio di errore
    exit    #Fermo lo script
fi
echo "Installazione di Wine (necessario ad eseguire i programmi compilati per Windows) in corso..."
if sudo aptitude install winehq-stable;then
    echo "Installazione di Wine effettuata con successo!"
else    #Altrimenti
    echo "Installazione fallita!"   #Messaggio di errore
    exit    #Fermo lo script
fi
mkdir tmp_install_project_manager   #Creo la cartella temporanea
cd tmp_install_project_manager  #Mi ci sposto dentro
#Scarico gli script
echo "Scarico gli script del project manager..."
#Scarico compile.sh
if wget http://gabrieleprinciotta.altervista.org/project_manager/compile.sh; then   #Se si puo' scaricare
    echo "'compile.sh' scaricato con successo!"
else    #ALtrimenti
    echo "Impossibile scaricare 'compile.sh'!"   #Messaggio di errore
    exit    #Fermo lo script
fi
#Scarico new_project.sh
if wget http://gabrieleprinciotta.altervista.org/project_manager/new_project.sh; then   #Se si puo' scaricare
    echo "'new_project.sh' scaricato con successo!"
else    #ALtrimenti
    echo "Impossibile scaricare 'new_project.sh'!"   #Messaggio di errore
    exit    #Fermo lo script
fi
#Li copio nella cartelle /usr/share/
#Copio compile.sh
if sudo cp compile.sh /usr/share/compile.sh; then   #Se si puo' copiare
    echo "'compile.sh' copiato in /usr/share/"
else    #Altrimenti
    echo "Impossibile copiare 'compile.sh' in /usr/share/ !"    #Messaggio di errore
    exit    #Fermo lo script
fi
#Copio new_project.sh
if sudo cp new_project.sh /usr/share/new_project.sh; then   #Se si puo' copiare
    echo "'new_project.sh' copiato in /usr/share/"
else    #Altrimenti
    echo "Impossibile copiare 'new_project.sh' in /usr/share/ !"    #Messaggio di errore
    exit    #Fermo lo script
fi
#Gli imposto i permessi di esecuzione
if sudo chmod +x /usr/share/compile.sh /usr/share/new_project.sh; then #Se gli cambia i permessi
    echo "Permessi di esecuzione cambiati con successo!"
else
    echo "Impossibile cambiare i permessi di esecuzione!"   #Messaggio di errore
    exit    #Fermo lo script
fi
#Scarico il file tasks.json
#Scarico tasks.json
if wget http://gabrieleprinciotta.altervista.org/project_manager/tasks.json; then   #Se si puo' scaricare
    echo "'tasks.json' scaricato con successo!"
else    #ALtrimenti
    echo "Impossibile scaricare 'tasks.json'!"   #Messaggio di errore
    exit    #Fermo lo script
fi
#Scarico new_project con interfaccia grafica
if wget http://gabrieleprinciotta.altervista.org/project_manager/new_project; then  #Se si puo' scaricare
    echo "'new_project' scaricato con successo!"
else    #Altrimenti
    echo "Impossibile scaricare 'new_project'!"
    exit    #Fermo lo script
fi
#Lo copio in /usr/bin/
if sudo cp new_project /usr/bin/new_project && sudo chmod +x /usr/bin/new_project; then   #Se si puo' copiare
    echo "'new_project' copiato in /usr/bin/"
else    #Altrimenti
    echo "Impossibile copiare 'new_project' in /usr/bin/"
    exit    #Fermo lo script
fi
#Chiedo all'utente la cartella dello Workspace
echo "Inserisci la cartella dello Workspace (ad esempio "$HOME"/Software/):"
read cartella_workspace #Prendo in input la cartella dello Workspace
#Copio il file tasks.json nel Workspace
if cp tasks.json $cartella_workspace/.vscode/tasks.json; then    #Se lo ho copiato
    echo "File 'tasks.json' copiato con successo!"
    echo "Installazione completata!"
else    #Altrimenti
    echo "Impossibile copiare il file 'tasks.json'!"
    echo "Installazione incompleta!"
    exit    #Fermo lo script
fi
#Esco dalla cartella
cd ..
#ELimino la cartella
rm -r tmp_install_project_manager
