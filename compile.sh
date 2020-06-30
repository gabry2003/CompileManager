#!/bin/bash

## Project      : Compile Manager
## Description  : Un programma che facilita la compilazione del codice sorgente in diversi linguaggi senza l'utilizzo di alcun IDE
## File         : compile.sh
## Author       : Gabriele Princiotta
## Date         : 11/06/2020

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

# Funzione per stampare a schermo il titolo del programma
shw_title () {
    tput bold; tput setaf 3; cat /opt/compileManager/logo.txt; tput sgr 0
}

avviaProgramma () { # Funzione per avviare un programma in una nuova finestra di terminale

    percorso=$1
    xterm -hold -e "$percorso"

}

# Trovo il package manager del sistema operativo
package_manager=""
declare -A osInfo;
osInfo[/etc/debian_version]="apt"
osInfo[/etc/centos-release]="yum"
osInfo[/etc/fedora-release]="yum"
osInfo[/etc/redhat-release]="yum"
osInfo[/etc/arch-release]="pacman"

for f in ${!osInfo[@]}
do
    if [[ -f $f ]]; then
        package_manager=${osInfo[$f]}
    fi
done

compilazione_linux_64="1"
compilazione_linux_32="1"
compilazione_windows_64="1"
compilazione_windows_32="1"
returnVal=""

getCompErr() {  # Funzione che ritorna il numero di compilazioni fallite di fila attuali

    cartella=$1
    if test -f $cartella/.compileError; then
        returnVal=$(cat $cartella/.compileError)
    else
        returnVal="0"
    fi

}

incCompErr () { # Funzione per incrementare il numero di compilazioni fallite

    cartella=$1
    getCompErr $cartella
    returnVal=$(( $returnVal + 1 ))
    echo $returnVal > $cartella/.compileError

}

resetCompErr () {   # Funzione per resettare il contatore delle compilazioni fallite

    cartella=$1
    echo "0" > $cartella/.compileError

}

tipoFile () {   # Funzione per trovare il tipo di file

    nomeFile=$1     # Nome del file
    estensione=${nomeFile#*.}   # Estensione del file

    if [ "$estensione" == "c" ]; then
        echo "c"
    elif [ "$estensione" == "cpp" ] || [ "$estensione" == "cxx" ] || [ "$estensione" == "cc" ] || [ "$estensione" == "c++" ]; then    # Se e' un file c++
        echo "c++"
    elif [ "$estensione" == "py" ]; then
        echo "python"
    elif [ "$estensione" == "kt" ]; then
        echo "kotlin"
    else
        echo ""
    fi

}

compilaFile () {    # Funzione per compilare il file

    nomeFile=$1                 # Nome del file
    eseguire=$2                 # Se eseguire dopo la compilazione
    baseFile=${nomeFile%%.*}    # Nome del file senza estensione
    estensione=${nomeFile#*.}   # Estensione del file
    tipo=$(tipoFile $nomeFile)  # Linguaggio
    successo="1"                # Se ha avuto successo

    if [ "$tipo" != "" ]; then

        shw_info "Linguaggio: $tipo"

        if [ "$tipo" == "c" ]; then

            if gcc $nomeFile -Wall -fstack-protector-all -pipe -O2 -g -o $baseFile; then
                shw_green "Compilazione effettuata con successo!"
            else

                shw_err "Impossibile effettuare la compilazione!"
                successo="0"

            fi

        elif  [ "$tipo" == "c++" ]; then

            if g++ $nomeFile -Wall -fstack-protector-all -pipe -O2 -g -o $baseFile; then
                shw_green "Compilazione effettuata con successo!"
            else

                shw_err "Impossibile effettuare la compilazione!"
                successo="0"
                
            fi

        elif [ "$tipo" == "python" ]; then

            cd $(dirname $nomeFile)
            if pyinstaller --onefile $nomeFile && rm -rf $(dirname $nomeFile)/build && rm -rf $(dirname $nomeFile)/__pycache__ && rm $(dirname $nomeFile)/$(basename $baseFile).spec && mv $(dirname $nomeFile)/dist/$(basename $baseFile) $(dirname $nomeFile)/$(basename $baseFile) && rm -rf $(dirname $nomeFile)/dist/; then
                shw_green "Compilazione effettuata con successo!"
            else

                shw_err "Impossibile effettuare la compilazione!"
                successo="0"
                
            fi

        elif [ "$tipo" == "kotlin" ]; then

            if kotlinc-native $nomeFile -o $baseFile; then
                shw_green "Compilazione effettuata con successo!"
            else

                shw_err "Impossibile effettuare la compilazione!"
                successo="0"
            fi

        fi

        if [ "$successo" == "1" ]; then

            shw_info "Eseguibile disponibile su $baseFile"
            resetCompErr $(dirname $nomeFile)

        else

            incCompErr $(dirname $nomeFile)

            if [ "$returnVal" -ge "3" ]; then  # Se e' la terza volta di fila almeno

                getCompErr $(dirname $nomeFile)
                shw_warn "E' la $returnVal° volta di fila che la compilazione non ha successo, hai bisogno di una mano? AHAHAHAHAHAH"

            fi
            exit

        fi

        if [ "$eseguire" == "1" ]; then

            shw_info "Avvio il programma..."
            avviaProgramma "$(dirname $nomeFile)/./$(basename $baseFile)"

        fi

    else
        shw_err "Linguaggio non supportato!"
    fi

}

tipoProgetto () {   # Funzione per trovare il tipo di file del progetto

    cartella=$1     # Cartella
    tipoProgetto="" # Tipo da ritornare

    for nomeFile in $cartella/*; do

        estensione=${nomeFile#*.}   # Estensione del file

        if [ "$estensione" == "c" ]; then

            tipoProgetto="c"
            break

        elif [ "$estensione" == "cpp" ] || [ "$estensione" == "cxx" ] || [ "$estensione" == "cc" ] || [ "$estensione" == "c++" ]; then    # Se e' un file c++
            
            tipoProgetto="c++"
            break

        elif [ "$estensione" == "py" ]; then
            
            tipoProgetto="python"
            break

        elif [ "$estensione" == "kt" ]; then
            
            tipoProgetto="kotlin"
            break

        fi

    done

    echo $tipoProgetto

}

compilaProgettoWindows64Bit() { # Funzione per compilare il progetto per Windows a 64 bit

    cartella=$1
    suWindows=$2
    suLinux=$3
    su32Bit=$4
    architettura=$5
    nomeProgetto=$6
    eseguire=$7
    tipo=$(tipoProgetto $cartella)

    if [ "$suWindows" == "1" ] && [ "$architettura" == "x86_64" ] && [ "$tipo" != "kotlin" ] && [ "$tipo" != "python" ]; then    # Se e' disponibile per Windows e il computer e' a 64 bit

        # Provo a compilare
        shw_info "Linguaggio: $tipo"

        # pre-compilazione
        # Verifico l'esistenza della cartella
        if ! test -d $cartella/release/windows/64bit/; then
            mkdir -p $cartella/release/windows/64bit/
        fi

        if [ "$tipo" == "c++" ]; then   # Se e' un progetto C++

            if x86_64-w64-mingw32-g++ $( find $cartella -type f \( -iname \*.cpp -o -iname \*.cxx -o -iname \*.cc -o -iname \*.c++ \) ) -o $cartella/release/windows/64bit/$nomeProgetto -static -static-libgcc -static-libstdc++ -Wl,-Bstatic -lstdc++ -pthread -Wl,-Bdynami -std=c++0x -Wall -fstack-protector-all -pipe -O2 -g; then
                successo="1"
            else
                successo="0"
            fi
            

        else   # Se e' un progetto C

            if x86_64-w64-mingw32-gcc *.c -o $cartella/release/windows/64bit/$nomeProgetto -static -static-libgcc -static-libstdc++ -Wl,-Bstatic -lstdc++ -pthread -Wl,-Bdynami -std=c++0x -Wall -fstack-protector-all -pipe -O2 -g; then
                successo="1"
            else
                successo="0"
            fi

        fi

        # post-compilazione
        if [ "$successo" == "1" ]; then
            shw_green "Compilazione per Windows a 64 bit effettuata con successo!"
        else

            shw_warn "Compilazione fallita per Windows a 64 bit!"
            compilazione_windows_64="0"

        fi

    else
        shw_warn "Progetto non disponibile per Windows a 64 bit"
    fi

}

compilaProgettoWindows32Bit() { # Funzione per compilare il progetto per Windows a 32 bit

    cartella=$1
    suWindows=$2
    suLinux=$3
    su32Bit=$4
    architettura=$5
    nomeProgetto=$6
    eseguire=$7
    tipo=$(tipoProgetto $cartella)

    if [ "$suWindows" == "1" ] && [ "$su32Bit" == "1" ] && [ "$tipo" != "kotlin" ] && [ "$tipo" != "python" ]; then    # Se e' disponibile per Windows e per 32 bit

        # Provo a compilare
        shw_info "Linguaggio: $tipo"

        # pre-compilazione
        # Verifico l'esistenza della cartella
        if ! test -d $cartella/release/windows/32bit/; then
            mkdir -p $cartella/release/windows/32bit/
        fi

        if [ "$tipo" == "c++" ]; then   # Se e' un progetto C++

            if i686-w64-mingw32-g++ $( find $cartella -type f \( -iname \*.cpp -o -iname \*.cxx -o -iname \*.cc -o -iname \*.c++ \) ) -o $cartella/release/windows/32bit/$nomeProgetto -static -static-libgcc -static-libstdc++ -Wl,-Bstatic -lstdc++ -pthread -Wl,-Bdynami -std=c++0x -Wall -fstack-protector-all -pipe -O2 -g; then
                successo="1"
            else
                successo="0"
            fi
            

        else   # Se e' un progetto C

            if i686-w64-mingw32-gcc *.c -o $cartella/release/windows/32bit/$nomeProgetto -static -static-libgcc -static-libstdc++ -Wl,-Bstatic -lstdc++ -pthread -Wl,-Bdynami -std=c++0x -Wall -fstack-protector-all -pipe -O2 -g; then
                successo="1"
            else
                successo="0"
            fi

        fi

        # post-compilazione
        if [ "$successo" == "1" ]; then
            shw_green "Compilazione per Windows a 32 bit effettuata con successo!"
        else

            shw_warn "Compilazione fallita per Windows a 32 bit!"
            compilazione_windows_32="0"

        fi
    
    else
        shw_warn "Progetto non disponibile per Windows a 32 bit"
    fi

}

compilaProgettoLinux64Bit() {   # Funzione per compilare il progetto per Linux a 64 bit

    cartella=$1
    suWindows=$2
    suLinux=$3
    su32Bit=$4
    architettura=$5
    nomeProgetto=$6
    eseguire=$7
    tipo=$(tipoProgetto $cartella)
    successo="1"

    if [ "$suLinux" == "1" ] && [ "$architettura" == "x86_64" ]; then    # Se e' disponibile per Windows e il computer e' a 64 bit

        # Provo a compilare
        shw_info "Linguaggio: $tipo"

        # pre-compilazione
        # Verifico l'esistenza della cartella
        if ! test -d $cartella/release/linux/64bit/; then
            mkdir -p $cartella/release/linux/64bit/
        fi

        if [ "$tipo" == "c++" ]; then   # Se e' un progetto C++

            if g++ -Wall -fstack-protector-all -pipe -O2 -g $( find $cartella -type f \( -iname \*.cpp -o -iname \*.cxx -o -iname \*.cc -o -iname \*.c++ \) ) -o $cartella/release/linux/64bit/$nomeProgetto; then
                successo="1"
            else
                successo="0"
            fi
            

        elif [ "$tipo" == "c" ]; then   # Se e' un progetto C

            if g++ -Wall -fstack-protector-all -pipe -O2 -g *.c -o $cartella/release/linux/64bit/$nomeProgetto; then
                successo="1"
            else
                successo="0"
            fi

        elif [ "$tipo" == "python" ]; then  # Se e' un progetto Python

            if cd $cartella && pyinstaller --onefile $cartella/main_app.py && rm -rf $cartella/build && rm -rf $cartella/__pycache__ && rm $cartella/*.spec && mv $cartella/dist/main_app $cartella/release/linux/64bit/$nomeProgetto && rm -rf $cartella/dist/; then
                successo="1"
            else
                successo="0"                
            fi

        else    # Se e' un progetto kotlin

            if kotlinc-native $cartella/*.kt -o $cartella/release/linux/64bit/$nomeProgetto; then
                successo="1"
            else
                successo="0"
            fi
        fi

        # post-compilazione
        if [ "$successo" == "1" ]; then

            shw_green "Compilazione per linux a 64 bit effettuata con successo!"
            if [ "$architettura" == "x86_64" ] && [ "$eseguire" == "1" ]; then

                shw_info "Avvio il programma..."
                avviaProgramma "$cartella/release/linux/64bit/./$nomeProgetto"

            fi

        else

            shw_warn "Compilazione fallita per Linux a 64 bit!"
            compilazione_linux_64="0"

        fi
    
    else
        shw_warn "Progetto non disponibile per Linux a 64 bit"
    fi

}

compilaProgettoLinux32Bit() {   # Funzione per compilare il progetto per Linux a 32 bit

    cartella=$1
    suWindows=$2
    suLinux=$3
    su32Bit=$4
    architettura=$5
    nomeProgetto=$6
    eseguire=$7
    tipo=$(tipoProgetto $cartella)

    if [ "$suLinux" == "1" ] && [ "$su32Bit" == "1" ] && [ "$tipo" != "kotlin" ]; then    # Se e' disponibile per Windows e il computer e' a 64 bit

        # Provo a compilare
        shw_info "Linguaggio: $tipo"

        # pre-compilazione
        # Verifico l'esistenza della cartella
        if ! test -d $cartella/release/linux/32bit/; then
            mkdir -p $cartella/release/linux/32bit/
        fi

        if [ "$tipo" == "c++" ]; then   # Se e' un progetto C++

            if g++ -m32 -Wall -fstack-protector-all -pipe -O2 -g $( find $cartella -type f \( -iname \*.cpp -o -iname \*.cxx -o -iname \*.cc -o -iname \*.c++ \) ) -o $cartella/release/linux/32bit/$nomeProgetto; then
                successo="1"
            else
                successo="0"
            fi
        
        elif [ "$tipo" == "python" ]; then  # Se e' un progetto Python

            if [ "$architettura" != "x86_64" ]; then    # Se il computer e' a 32 bit

                if cd $cartella && pyinstaller --onefile $cartella/main_app.py && rm -rf $cartella/build && rm -rf $cartella/__pycache__ && rm $cartella/*.spec && mv $cartella/dist/main_app $cartella/release/linux/32bit/$nomeProgetto && rm -rf $cartella/dist/; then
                    successo="1"
                else
                    successo="0"                
                fi

            fi         

        else   # Se e' un progetto C

            if g++ -m32 -Wall -fstack-protector-all -pipe -O2 -g *.c -o $cartella/release/linux/32bit/$nomeProgetto; then
                successo="1"
            else
                successo="0"
            fi

        fi

        # post-compilazione
        if [ "$successo" == "1" ]; then

            shw_green "Compilazione per linux a 32 bit effettuata con successo!"
            
            if [ "$architettura" != "x86_64" ] && [ "$eseguire" == "1" ]; then

                shw_info "Avvio il programma..."
                avviaProgramma "$cartella/release/linux/32bit/./$nomeProgetto"

            fi

        else

            shw_warn "Compilazione fallita per Linux a 32bit!"
            compilazione_linux_32="0"

        fi
    
    else
        shw_warn "Progetto non disponibile per Linux a 32bit"
    fi

}

# Prendo la cartella del progetto
cartella_progetto=$1

# Prendo in input la scelta se eseguire o meno il programma dopo la compilazione
eseguire=$2

# Nascondo il logo
nascondiLogo=$3

if [ "$nascondiLogo" != "1" ]; then
    
    shw_title
    echo
    echo

fi

# Trovo l'architettura del sistema operativo
architettura=$(uname -i)

echo
shw_info "Rilevata architettura: $architettura"

echo
shw_info "Package manager: $package_manager"


if test -d "$cartella_progetto"; then   # Se e' una cartella

    if ! test -f "$cartella_progetto/infoPrj"; then     # Se non esiste il progetto

        shw_err "Progetto non esistente!"
        exit

    fi

    # Prendo il nome del progetto
    nome_progetto=$(head -1 $cartella_progetto/infoPrj | tail -1)
    if [ "$nome_progetto" == "" ]; then # Se non ha inserito il nome del progetto
        nome_progetto=$(basename $cartella_progetto)
    fi
    nome_progetto=${nome_progetto// /_} # Sostituisco gli spazi con gli underscore

    # Prendo l'autore del progetto
    autore_progetto=$(head -2 $cartella_progetto/infoPrj | tail -1)

    # Prendo la descrizione del progetto
    descrizione_progetto=$(head -3 $cartella_progetto/infoPrj | tail -1)

    # Prendo il tipo di UI (grafica o console, per ora solo console)
    tipo_grafica=$(head -4 $cartella_progetto/infoPrj | tail -1)

    # Prendo se e' disponibile per 32 bit
    thereIs32bit=$(head -5 $cartella_progetto/infoPrj | tail -1)

    # Prendo se e' disponibile per Linux
    thereIsLinux=$(head -6 $cartella_progetto/infoPrj | tail -1)

    # Prendo se e' disponibile per Windows
    thereIsWindows=$(head -7 $cartella_progetto/infoPrj | tail -1)

    echo
    shw_info "Cartella progetto: $cartella_progetto"
    shw_info "Tipo grafica: $tipo_grafica"

    if [ "$thereIs32bit" == "1" ]; then
        shw_info "Disponibile per 32 bit"
    fi

    if [ "$thereIsWindows" == "1" ]; then
        shw_info "Disponibile per Windows"
    fi

    if [ "$thereIsLinux" == "1" ]; then
        shw_info "Disponibile per Linux"
    fi

    echo

    if [ "$tipo_grafica" == "gui" ]; then   # Se e' un progetto ad interfaccia grafica

        cd $cartella_progetto   # Mi sposto nella cartella del progetto
        if ! test -f "$nome_progetto.desktop"; then    # Se non c'e' il file .desktop

            echo "[Desktop Entry]" > "$nome_progetto.desktop" # Aggiungo la riga al file
            echo "Type=Application" >> "$nome_progetto.desktop" # Aggiungo la riga al file
            echo "Name=$nome_progetto" >> "$nome_progetto.desktop" # Aggiungo la riga al file
            if [ "$architettura" == "x86_64" ]; then    #S e il computer e' a 64 bit
                echo "Exec=$cartella_progetto/release/linux/64bit/$nome_progetto" >> "$nome_progetto.desktop" # Aggiungo la riga al file
            else    # Altrimenti
                echo "Exec=$cartella_progetto/release/linux/32bit/$nome_progetto" >> "$nome_progetto.desktop" # Aggiungo la riga al file
            fi
            echo "Icon=$nome_progetto" >> "$nome_progetto.desktop" # Aggiungo la riga al file
            echo "Comment=$descrizione_progetto" >> "$nome_progetto.desktop" # Aggiungo la riga al file
            echo "Categories=Office;" >> "$nome_progetto.desktop" # Aggiungo la riga al file
            echo "X-AppImage-Version=" >> "$nome_progetto.desktop" # Aggiungo la riga al file

        fi

        # Al momento compila solo i progetti di QT Creator
        # Compilo il progetto
        cd $cartella_progetto
        make clean
        shw_info "Compilo per Linux..."

        if [ "$package_manager" == "apt" ]; then
            comando="qmake -qt=5"
        else
            comando="qmake-qt5"
        fi

        if $($comando) && make; then   # Se compila il progetto

            if [ "$architettura" == "x86_64" ]; then

                if mv $nome_progetto release/linux/64bit/$nome_progetto; then

                    shw_green "Progetto compilato con successo. File eseguibile su $cartella_progetto/release/linux/64bit/$nome_progetto"
                    compilazione_linux_64="1"
                    compilazione_linux_32="1"
                    compilazione_windows_64="1"
                    compilazione_windows_32="1"

                else

                    compilazione_linux_64="0"
                    compilazione_linux_32="0"
                    compilazione_windows_64="0"
                    compilazione_windows_32="0"
                    shw_err "Impossibile compilare il progetto!"

                fi

            else

                if mv $nome_progetto release/linux/32bit/$nome_progetto; then

                    shw_green "Progetto compilato con successo. File eseguibile su $cartella_progetto/release/linux/32bit/$nome_progetto"
                    compilazione_linux_64="1"
                    compilazione_linux_32="1"
                    compilazione_windows_64="1"
                    compilazione_windows_32="1"

                else

                    compilazione_linux_64="0"
                    compilazione_linux_32="0"
                    compilazione_windows_64="0"
                    compilazione_windows_32="0"
                    shw_err "Impossibile compilare il progetto!"

                fi

            fi
        else

            shw_err "Impossibile compilare il progetto!"
            incCompErr $cartella_progetto

        fi
        make clean

    else    # Se e' un progetto a console

        if [ "$thereIsWindows" == "1" ]; then   # Se e' disponibile per Windows

            if [ "$architettura" == "x86_64" ]; then    # Se il computer e' a 64 bit
                compilaProgettoWindows64Bit $cartella_progetto $thereIsWindows $thereIsLinux $thereIs32bit $architettura $nome_progetto $eseguire
            fi

            if  [ "$thereIs32bit" == "1" ]; then    # Se e' disponibile per 32 bit
                compilaProgettoWindows32Bit $cartella_progetto $thereIsWindows $thereIsLinux $thereIs32bit $architettura $nome_progetto $eseguire
            fi

        fi

        if [ "$thereIsLinux" == "1" ]; then   # Se e' disponibile per Linux
            
            if [ "$architettura" == "x86_64" ]; then    # Se il computer e' a 64 bit
                compilaProgettoLinux64Bit $cartella_progetto $thereIsWindows $thereIsLinux $thereIs32bit $architettura $nome_progetto $eseguire
            fi

            if  [ "$thereIs32bit" == "1" ]; then    # Se e' disponibile per 32 bit
                compilaProgettoLinux32Bit $cartella_progetto $thereIsWindows $thereIsLinux $thereIs32bit $architettura $nome_progetto $eseguire
            fi

        fi

        if [ "$compilazione_windows_64" == "0" ] || [ "$compilazione_windows_32" == "0" ] || [ "$compilazione_linux_64" == "0" ] || [ "$compilazione_linux_32" == "0" ]; then

            shw_warn "Compilazione fallita in una o piu' distribuzioni!"
            incCompErr $cartella_progetto
            exit

        else

            resetCompErr $cartella_progetto
            exit

        fi

    fi
else    # Altrimenti

    # Devo compilare solamente il file passato
    if test -f "$cartella_progetto"; then   # Se il file esiste
        compilaFile $cartella_progetto $eseguire
    else

        shw_err "File inesistente!"
        exit

    fi

fi
