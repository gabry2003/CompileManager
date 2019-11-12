#! /bin/bash
#title          :new_project.sh
#description    :Con questo script puoi creare un nuovo progetto in C o C++
#author         :Gabriele Princiotta
#date           :02-11-2019
#version        :1.0
#note           :Da abbinare a compile.sh e new_project con l'interfaccia grafica
#Prendo la cartella del progetto
cartella_progetto=$1
linguaggio_utilizzato=$2
tipo_interfaccia_grafica=$3
distribuzione_progetto=$4
autore_progetto=$5
nome_progetto=$6
descrizione_progetto=$7
#Controllo che non esista gia' il file info
if test -f $cartella_progetto/info; then
    echo "Esiste gia' un progetto in questa cartella, vuoi modificarlo (s o n) ?:"
    read modificare    #Prendo in input la scelta se modificare o no il progetto
    if [ "$modificare" == "n" ] || [ "$modificare" == "N" ]; then #Se ha scelto di non modificarlo
        #Fermo lo script
        exit
    fi
fi
#Creo il file del progetto
if ! touch $cartella_progetto/info; then  #Se non ha creato il file del progetto
    echo "Impossibile creare il file del progetto!"
    #Fermo lo script
    exit
fi
#Linguaggio utilizzato
if [ $linguaggio_utilizzato == "C++" ]; then    #Se ha scelto C++
    if ! echo "c++" > $cartella_progetto/info; then #Se non cambia il contenuto del file del progetto
        #Fermo lo script
        echo "Impossibile creare il file del progetto!"
        exit
    fi
else    #Altrimenti
    if ! echo "c" > $cartella_progetto/info; then #Se non cambia il contenuto del file del progetto
        #Fermo lo script
        echo "Impossibile creare il file del progetto!"
        exit
    fi
fi
#Tipo di interfaccia grafica
if [ $tipo_interfaccia_grafica == "Console" ]; then    #Se ha scelto console
    if ! echo "console" >> $cartella_progetto/info; then #Se non aggiunge la riga al file del progetto
        #Fermo lo script
        echo "Impossibile creare il file del progetto!"
        exit
    fi
else    #Altrimenti
    if ! echo "gui" >> $cartella_progetto/info; then #Se non aggiunge la riga al file del progetto
        #Fermo lo script
        echo "Impossibile creare il file del progetto!"
        exit
    fi
fi
#Distribuzione progetto
#Sia Linux che Windows = 1
#Solo Linux = 2
#Solo Windows = 3
if ! echo $distribuzione_progetto >> $cartella_progetto/info; then  #Se non aggiunge la riga al file del progetto
    #Fermo lo script
    echo "Impossibile creare il file del progetto!"
    exit
fi
#Autore progetto
if ! echo $autore_progetto >> $cartella_progetto/info; then #Se non aggiunge la riga al file del progetto
    #Fermo lo script
    echo "Impossibile creare il file del progetto!"
    exit
fi
#Nome progetto
if ! echo $nome_progetto >> $cartella_progetto/info; then #Se non aggiunge la riga al file del progetto
    #Fermo lo script
    echo "Impossibile creare il file del progetto!"
    exit
fi
#Descrizione progetto
if ! echo $descrizione_progetto >> $cartella_progetto/info; then #Se non aggiunge la riga al file del progetto
    #Fermo lo script
    echo "Impossibile creare il file del progetto!"
    exit
else    #Altrimenti
    echo "Progetto creato con successo!"
    echo "Scrivi \"0\" per chiudere il programma"
    read chiusura
    if [ $chiusura == "0" ]; then
        killall AppRun #Chiudo new_project con l'interfaccia grafica
        killall xterm   #Chiudo il terminale
    fi
fi