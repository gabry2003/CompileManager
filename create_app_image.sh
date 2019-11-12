#! /bin/bash
#title          :create_app_image.sh
#description    :Con questo script puoi creare un .AppImage del tuo progetto QT creato con Project Manager per poterlo distribuire
#author         :Gabriele Princiotta
#date           :12-11-2019
#version        :1.0
bold=$(tput bold)   #Testo in grassetto
normal=$(tput sgr0) #Testo normale
cartella_progetto=$1    #Prendo la cartella del progetto
eseguire=$2 #Prendo in input se eseguire alla fine o no
#Architettura processore
architettura=$(uname -i)
#Prendo il tipo di UI (grafica o console, per ora solo console)
tipo_grafica=$(head -2 $cartella_progetto/info | tail -1)
#Prendo il nome del progetto
nome_progetto=$(head -5 $cartella_progetto/info | tail -1)
if [ "$tipo_grafica" == "gui" ]; then   #Se e' un progetto con interfaccia grafica
    #Mi sposto nella cartella del progetto
    cd $cartella_progetto
    if ! test -f "$cartella_progetto/release/linux/64bit/$nome_progetto" && ! test -f "$cartella_progetto/release/linux/32bit/$nome_progetto"; then   #Se il progetto non e' stato compilato
        #Lo compilo
        bash /usr/share/compile.sh "$cartella_progetto" "0"
    fi
    #Utilizzo linuxdeployqt
    if linuxdeployqt $nome_progetto.desktop -unsupported-allow-new-glibc -verbose=1 -no-translations -no-copy-copyright-files -extra-plugins=iconengines,platformthemes/libqgtk3.so; then
        echo "File per creare l'AppImage generati con successo!"
    else
        tput setaf 1; echo "Impossibile creare i file per l'AppImage!"
        exit    #Fermo lo script
    fi
    #I file verranno generati nella cartella dove risiede l'eseguibile
    #Se sono su 64 bit su $cartella_progetto/release/linux/64bit/
    #Altrimenti su $cartella_progetto/release/linux/32bit
    #Controllo se c'e' un'icona nella cartella del progetto
    if test -f $cartella_progetto/$nome_progetto.png; then #Se c'e' l'icona
        #La copio all'interno nella cartella di rilascio
        if [ "$architettura" == "x86_64" ]; then    #Se il computer e' a 64 bit
            cp $cartella_progetto/release/linux/64bit/$nome_progetto.png
        else    #Altrimenti
            cp $cartella_progetto/release/linux/32bit/$nome_progetto.png
        fi
    fi
    #Creo l'AppImage
    if [ "$architettura" == "x86_64" ]; then    #Se il computer e' a 64 bit
        #Se non c'e' un icona nella cartella del progetto ne scarico una di default
        if ! test -f $cartella_progetto/release/linux/64bit/$nome_progetto.png; then   #Se non c'e' gia' l'icona
            cd $cartella_progetto/release/linux/64bit/
            wget https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/Application-default-icon.svg/240px-Application-default-icon.svg.png  #Scarico l'icona
            mv $cartella_progetto/release/linux/64bit/240px-Application-default-icon.svg.png $cartella_progetto/release/linux/64bit/$nome_progetto.png    #La rinomino
        fi
        if appimagetool $cartella_progetto/release/linux/64bit; then #Se creo l'AppImage
            mv $cartella_progetto/release/linux/64bit/*.AppImage $cartella_progetto/release/linux/64bit/$nome_progetto.AppImage #La rinomino
            echo "${bold}AppImage creato con successo!"
            echo "E' disponibile su \"$cartella_progetto/release/linux/64bit/$nome_progetto.AppImage\"${normal}"
            #Elimino tutti i file tranne il .AppImage
            for file in $( ls $cartella_progetto/release/linux/64bit/ ); do #Controllo ogni file e cartella della cartella di rilascio
                if [ $file != $nome_progetto.AppImage ]; then   #Se il file o cartella non e' il .AppImage
                    rm -rf $file    #Lo elimino
                fi
            done
            echo "Apertura in corso..."
            if [ "$eseguire" == "1" ]; then #Se l'utente ha scelto di eseguire alla fine
                if ! $cartella_progetto/release/linux/64bit/./$nome_progetto.AppImage; then    #Se non posso eseguire l'AppImage
                    tput setaf 1; echo "Impossibile eseguire il file .AppImage!"
                    exit    #Fermo lo script
                fi
            fi
        else
            tput setaf 1; echo "Impossibile creare il file .AppImage!"
            exit    #Fermo lo script
        fi
    else    #Altrimenti, se il computer e' a 32 bit
        #Se non c'e' un icona nella cartella del progetto ne scarico una di default
        if ! test -f $cartella_progetto/release/linux/64bit/$nome_progetto.png; then   #Se non c'e' gia' l'icona
            cd $cartella_progetto/release/linux/64bit/
            wget https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/Application-default-icon.svg/240px-Application-default-icon.svg.png  #Scarico l'icona
            mv $cartella_progetto/release/linux/64bit/240px-Application-default-icon.svg.png $cartella_progetto/release/linux/64bit/$nome_progetto.png    #La rinomino
        fi
        if appimagetool $cartella_progetto/release/linux/32bit; then #Se creo l'AppImage
            mv $cartella_progetto/release/linux/32bit/*.AppImage $cartella_progetto/release/linux/32bit/$nome_progetto.AppImage #La rinomino
            echo "${bold}AppImage creato con successo!"
            echo "E' disponibile su \"$cartella_progetto/release/linux/32bit/$nome_progetto.AppImage\"${normal}"
            #Elimino tutti i file tranne il .AppImage
            for file in $( ls $cartella_progetto/release/linux/32bit/ ); do #Controllo ogni file e cartella della cartella di rilascio
                if [ $file != $nome_progetto.AppImage ]; then   #Se il file o cartella non e' il .AppImage
                    rm -rf $file    #Lo elimino
                fi
            done
            echo "Apertura in corso..."
            if [ "$eseguire" == "1" ]; then #Se l'utente ha scelto di eseguire alla fine
                if ! $cartella_progetto/release/linux/32bit/./$nome_progetto.AppImage; then    #Se non posso eseguire l'AppImage
                    tput setaf 1; echo "Impossibile eseguire il file .AppImage!"
                    exit    #Fermo lo script
                fi
            fi
        else
            tput setaf 1; echo "Impossibile creare il file .AppImage!"
            exit    #Fermo lo script
        fi
    fi
else
    tput setaf 1; echo "Non puoi creare un AppImage da un progetto console!"
    exit    #Fermo lo script
fi
