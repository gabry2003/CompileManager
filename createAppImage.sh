#!/bin/sh

## Project      : Compile Manager
## Description  : Un programma che facilita la compilazione del codice sorgente in diversi linguaggi senza l'utilizzo di alcun IDE
## File         : createAppImage.sh
## Author       : Gabriele Princiotta
## Date         : 10/06/2020

# Funzioni per stampare a schermo il testo con diversi colori
shw_green () {
    echo $(tput bold)$(tput setaf 2) $@ $(tput sgr 0)
}

shw_info () {
    echo $(tput bold)$(tput setaf 4) $@ $(tput sgr 0)
}

shw_warn () {
    echo $(tput bold)$(tput setaf 3) $@ $(tput sgr 0)
}

shw_err ()  {
    echo $(tput bold)$(tput setaf 1) $@ $(tput sgr 0)
}

shw_title () {  # Funzione per stampare a schermo il titolo del programma
    tput bold; tput setaf 3; cat /opt/compileManager/logo.txt; tput sgr 0
}

# Trovo l'architettura del sistema operativo
architettura=$(uname -i)

shw_title

echo
echo

cartella_progetto=$1    # Prendo la cartella del progetto
eseguire=$2 # Prendo in input se eseguire alla fine o no

if [ "$cartella_progetto" == "help" ]; then
    shw_info "Guida:"
    shw_info "./createAppImage.sh [cartellaProgetto] [eseguire]"
    shw_info "dove"
    shw_info "[cartellaProgetto] e' la cartella del progetto QT"
    shw_info "[eseguire] puo' essere 0/1, dove 1 indica che viene eseguito alla fine e 0 il contrario"
    echo
    exit
fi

echo
shw_info "Rilevata architettura: $architettura"

# Controllo se e' stata passata una cartella come argomento
if ! test -d "$cartella_progetto"; then
    shw_err "Non hai inserito il percorso di una cartella!"
    exit
fi

# Controllo se esiste il file del progetto
if ! test -f "$cartella_progetto/infoPrj"; then
    shw_err "Non esiste nessun progetto in questa cartella!"
    exit
fi

# Prendo il tipo di UI (grafica o console, per ora solo console)
tipo_grafica=$(head -4 $cartella_progetto/infoPrj | tail -1)

# Prendo il nome del progetto
nome_progetto=$(head -1 $cartella_progetto/infoPrj | tail -1)

if [ "$nome_progetto" == "" ]; then # Se non ha inserito il nome del progetto
    nome_progetto=$(basename $cartella_progetto)
fi

if [ "$tipo_grafica" == "gui" ]; then   # Se e' un progetto con interfaccia grafica

    # Mi sposto nella cartella del progetto
    cd $cartella_progetto
    sh /opt/compileManager/compile.sh "$cartella_progetto" "0" "1" # Lo compilo

    # Utilizzo linuxdeployqt
    if linuxdeployqt $nome_progetto.desktop -unsupported-allow-new-glibc -verbose=1 -no-translations -no-copy-copyright-files -extra-plugins=iconengines,platformthemes/libqgtk3.so; then
        shw_green "File per creare l'AppImage generati con successo!"
    else
        shw_warn "Impossibile creare i file per l'AppImage!"
    fi

    # I file verranno generati nella cartella dove risiede l'eseguibile
    # Se sono su 64 bit su $cartella_progetto/release/linux/64bit/
    # Altrimenti su $cartella_progetto/release/linux/32bit
    # Controllo se c'e' un'icona nella cartella del progetto

    if test -f $cartella_progetto/$nome_progetto.png; then # Se c'e' l'icona
        # La copio all'interno nella cartella di rilascio
        if [ "$architettura" == "x86_64" ]; then    # Se il computer e' a 64 bit
            cp $cartella_progetto/$nome_progetto.png $cartella_progetto/release/linux/64bit/$nome_progetto.png
        else    # Altrimenti
            cp $cartella_progetto/$nome_progetto.png $cartella_progetto/release/linux/32bit/$nome_progetto.png
        fi
    fi

    # Creo l'AppImage
    if [ "$architettura" == "x86_64" ]; then    # Se il computer e' a 64 bit
        # Se non c'e' un icona nella cartella del progetto ne scarico una di default
        if ! test -f $cartella_progetto/release/linux/64bit/$nome_progetto.png; then   # Se non c'e' gia' l'icona
            cd $cartella_progetto/release/linux/64bit/
            wget https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/Application-default-icon.svg/240px-Application-default-icon.svg.png  # Scarico l'icona
            mv $cartella_progetto/release/linux/64bit/240px-Application-default-icon.svg.png $cartella_progetto/release/linux/64bit/$nome_progetto.png    # La rinomino
        fi
        if /usr/bin/./appimagetool.AppImage $cartella_progetto/release/linux/64bit; then # Se creo l'AppImage
            mv $cartella_progetto/*.AppImage $cartella_progetto/release/linux/64bit/$nome_progetto.AppImage # La rinomino
            shw_green "AppImage creato con successo!"
            shw_info "E' disponibile su \"$cartella_progetto/release/linux/64bit/$nome_progetto.AppImage\"${normal}"
            # Elimino tutti i file tranne il .AppImage
            for file in $( ls $cartella_progetto/release/linux/64bit/ ); do # Controllo ogni file e cartella della cartella di rilascio
                if [ $file != $nome_progetto.AppImage ]; then   # Se il file o cartella non e' il .AppImage
                    rm -rf $file    # Lo elimino
                fi
            done
            echo "Apertura in corso..."
            if [ "$eseguire" == "1" ]; then # Se l'utente ha scelto di eseguire alla fine
                if ! $cartella_progetto/release/linux/64bit/./$nome_progetto.AppImage; then    # Se non posso eseguire l'AppImage

                    shw_err "Impossibile eseguire il file .AppImage!"
                    exit    # Fermo lo script

                fi
            fi
        else

            shw_err "Impossibile creare il file .AppImage!"
            exit    # Fermo lo script

        fi

    else    # Altrimenti, se il computer e' a 32 bit

        # Se non c'e' un icona nella cartella del progetto ne scarico una di default
        if ! test -f $cartella_progetto/release/linux/32bit/$nome_progetto.png; then   # Se non c'e' gia' l'icona

            cd $cartella_progetto/release/linux/32bit/
            wget https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/Application-default-icon.svg/240px-Application-default-icon.svg.png  # Scarico l'icona
            mv $cartella_progetto/release/linux/32bit/240px-Application-default-icon.svg.png $cartella_progetto/release/linux/32bit/$nome_progetto.png    # La rinomino

        fi

        if /usr/bin/./appimagetool.AppImage $cartella_progetto/release/linux/32bit; then # Se creo l'AppImage

            mv $cartella_progetto/*.AppImage $cartella_progetto/release/linux/32bit/$nome_progetto.AppImage # La rinomino
            shw_green "AppImage creato con successo!"
            shw_info "E' disponibile su \"$cartella_progetto/release/linux/32bit/$nome_progetto.AppImage\"${normal}"

            # Elimino tutti i file tranne il .AppImage
            for file in $( ls $cartella_progetto/release/linux/32bit/ ); do # Controllo ogni file e cartella della cartella di rilascio
                if [ $file != $nome_progetto.AppImage ]; then   # Se il file o cartella non e' il .AppImage
                    rm -rf $file    # Lo elimino
                fi
            done

            echo "Apertura in corso..."
            if [ "$eseguire" == "1" ]; then # Se l'utente ha scelto di eseguire alla fine

                if ! $cartella_progetto/release/linux/32bit/./$nome_progetto.AppImage; then    # Se non posso eseguire l'AppImage
                    shw_err "Impossibile eseguire il file .AppImage!"
                    exit    # Fermo lo script
                fi

            fi
        else

            shw_err "Impossibile creare il file .AppImage!"
            exit    # Fermo lo script
            
        fi
    fi

else

    shw_err "Non puoi creare un AppImage da un progetto console!"
    exit    # Fermo lo script

fi
