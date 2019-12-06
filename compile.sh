#! /bin/bash
#title          :compile.sh
#description    :Con questo script puoi compilare i progetti creati con new_project.sh
#author         :Gabriele Princiotta
#date           :02-11-2019
#version        :1.0
#note           :Da abbinare a new_project.sh e new_project
bold=$(tput bold)   #Testo in grassetto
normal=$(tput sgr0) #Testo normale
#Prendo la cartella del progetto
cartella_progetto=$1
#Per prima cosa controllo se esiste il file del progetto
if ! test -f "$cartella_progetto/info"; then
    echo "${bold}Progetto non esistente! Crealo...${normal}"
    if ! /usr/bin/./new_project.AppImage $cartella_progetto; then
        tput setaf 1; echo "Impossibile creare il progetto!"
    fi
fi
#Prendo in input la scelta se eseguire o meno il programma dopo la compilazione
eseguire=$2
#Architettura processore
architettura=$(uname -i)
#Prendo la distribuzione
#1 = Sia Linux che Windows
#2 = Solo Linux
#3 = Solo Windows
distribuzione=$(head -3 $cartella_progetto/info | tail -1)
#Prendo il tipo di UI (grafica o console, per ora solo console)
tipo_grafica=$(head -2 $cartella_progetto/info | tail -1)
#Prendo il nome del progetto
nome_progetto=$(head -5 $cartella_progetto/info | tail -1)
#Prendo la descrizione del progetto
descrizione_progetto=$(head -6 $cartella_progetto/info | tail -1)
#Numero di compilazioni fallite
if ! test -f $cartella_progetto/.comperror; then
    touch $cartella_progetto/.comperror
fi
comp_fallite=$(head -1 $cartella_progetto/.comperror | tail -1)
#Se le cartelle non esistono e le posso creare le creo, altrimenti fermo lo script
if [ $distribuzione == "1" ] || [ $distribuzione == "2" ]; then #Se rispetta le condizioni
    if [ "$architettura" == "x86_64" ]; then    #Se il computer e' a 64 bit
        if ! test -d $cartella_progetto/release/linux/64bit/; then
            echo "${normal}Creazione cartella per Linux a 64 bit..."
            output=$(mkdir -p $cartella_progetto/release/linux/64bit/)
            if $output;then
                echo "${bold}Cartella creata!"
            else
                tput setaf 1; echo "Impossibile creare la cartella!"
                exit
            fi
        fi
    fi
    if ! test -d $cartella_progetto/release/linux/32bit/; then
        echo "${normal}Creazione cartella per Linux a 32 bit..."
        output=$(mkdir -p $cartella_progetto/release/linux/32bit/)
        if $output;then
            echo "${bold}Cartella creata!"
        else
            tput setaf 1; echo "Impossibile creare la cartella!"
            exit
        fi
    fi
fi
if [ "$distribuzione" == "1" ] || [ "$distribuzione" == "3" ]; then #Se rispetta le condizioni
    if [ "$architettura" == "x86_64" ]; then    #Se il computer e' a 64 bit
        if ! test -d $cartella_progetto/release/windows/64bit/; then
            echo "${normal}Creazione cartella per Windows a 64 bit..."
            output=$(mkdir -p $cartella_progetto/release/windows/64bit/)
            if $output;then
                echo "${bold}Cartella creata!"
            else
                tput setaf 1; echo "Impossibile creare la cartella!"
                exit
            fi
        fi
    fi
    if ! test -d $cartella_progetto/release/windows/32bit/; then
        echo "${normal}Creazione cartella per Windows a 32 bit..."
        output=$(mkdir -p $cartella_progetto/release/windows/32bit/)
        if $output;then
            echo "${bold}Cartella creata!"
        else
            tput setaf 1; echo "Impossibile creare la cartella!"
            exit
        fi
    fi
fi
if [ "$tipo_grafica" == "gui" ]; then   #Se e' un progetto ad interfaccia grafica
    cd $cartella_progetto   #Mi sposto nella cartella del progetto
    if ! test -f "$nome_progetto.desktop"; then    #Se non c'e' il file .desktop
        echo "[Desktop Entry]" > "$nome_progetto.desktop" #Aggiungo la riga al file
        echo "Type=Application" >> "$nome_progetto.desktop" #Aggiungo la riga al file
        echo "Name=$nome_progetto" >> "$nome_progetto.desktop" #Aggiungo la riga al file
        if [ "$architettura" == "x86_64" ]; then    #Se il computer e' a 64 bit
            echo "Exec=$cartella_progetto/release/linux/64bit/$nome_progetto" >> "$nome_progetto.desktop" #Aggiungo la riga al file
        else    #Altrimenti
            echo "Exec=$cartella_progetto/release/linux/32bit/$nome_progetto" >> "$nome_progetto.desktop" #Aggiungo la riga al file
        fi
        echo "Icon=$nome_progetto" >> "$nome_progetto.desktop" #Aggiungo la riga al file
        echo "Comment=$descrizione_progetto" >> "$nome_progetto.desktop" #Aggiungo la riga al file
        echo "Categories=Office;" >> "$nome_progetto.desktop" #Aggiungo la riga al file
        echo "X-AppImage-Version=" >> "$nome_progetto.desktop" #Aggiungo la riga al file
    fi
fi
#Prendo il linguaggio utilizzato (C o C++)
tipo_progetto=$(head -1 $cartella_progetto/info | tail -1)
#Se e' C++
if [ "$tipo_progetto" == "c++" ]; then
    estensione_file=cpp
    #Siccome uso l'estensione .cpp per i file c++, ma si possono usare altre estensioni, le cambio tutte
    for file in $cartella_progetto/*.cc $cartella_progetto/*.cxx $cartella_progetto/*.c++; do
        #Se il file esiste
        if test -f $file; then
            estensione="${FILE##*.}"
            #Cambio l'estensione a tutti i file
            if mv $file ${file%.*}".cpp"; then
                echo "${bold}File "$file" rinominato in "${file%.*}".cpp"
            fi
        fi
    done
else
    #Se e' C
    estensione_file=c
fi
#Se i file contengono gli spazi, li sostituisco con un underscore
for FILE in $cartella_progetto/*.$estensione_file; do
    #Se il nome del file contiene spazi
    if [[ $FILE =~ " " ]];then
        mv "$FILE" $(echo $FILE | tr " " "_")
    fi
done
#Cartella corrente, per il nome del file eseguibile
current_dir=$(basename $cartella_progetto)
compilazione_linux_64="1"
compilazione_windows_32="1"
compilazione_linux_64="1"
compilazione_windows_32="1"
#Se il progetto e' a riga di comando
if [ "$tipo_grafica" == "console" ]; then
    if [ "$distribuzione" == "1" ] || [ "$distribuzione" == "2" ]; then  #Compilo per Linux solo se lo prevede il progetto
        #Compilo per Linux, per C o per C++
        #Compilo per 64 bit solo se sono su 64 bit
        if [ "$architettura" == "x86_64" ]; then
            echo "${normal}Compilo per Linux a 64 bit..."
            if [ "$tipo_progetto" == "c++" ]; then
                compilato="1"
                for file in $cartella_progetto/*.cpp; do   #Per tutti i file C++
                    #Li compilo uno ad uno
                    if ! g++ -c $file -o ${file/%cpp/o}; then   #Se non compila
                        compilato="0"
                    fi
                done
                if [ "$compilato" == "1" ]; then    #Se ha compilato i file
                    if g++ -g -O2 $cartella_progetto/*.o -o $cartella_progetto/release/linux/64bit/$current_dir -fexceptions -Wall;then
                        echo "${bold}Compilazione effettuata! File eseguibile su release/linux/64bit/"$current_dir
                        compilazione_linux_64="1"
                    else
                        compilazione_linux_64="0"
                    fi
                    rm -rf $cartella_progetto/*.o   #Elimino tutti i file .o
                fi
            else
                compilato="1"
                for file in $cartella_progetto/*.c; do   #Per tutti i file C
                    #Li compilo uno ad uno
                    if ! gcc -c $file -o ${file/%c/o}; then   #Se non compila
                        compilato="0"
                    fi
                done
                if [ "$compilato" == "1" ]; then    #Se ha compilato i file
                    if gcc -g -O2 $cartella_progetto/*.o -o $cartella_progetto/release/linux/64bit/$current_dir -fexceptions -Wall;then
                        echo "${bold}Compilazione effettuata! File eseguibile su release/linux/64bit/"$current_dir
                        compilazione_linux_64="1"
                    else
                        compilazione_linux_64="0"
                    fi
                    rm -rf $cartella_progetto/*.o   #Elimino tutti i file .o
                fi
            fi
        fi
        echo "${normal}Compilo per Linux a 32 bit..."
        if [ "$tipo_progetto" == "c++" ]; then
            compilato="1"
            for file in $cartella_progetto/*.cpp; do   #Per tutti i file C++
                    #Li compilo uno ad uno
                if ! g++ -m32 -c $file -o ${file/%cpp/o}; then   #Se non compila
                    compilato="0"
                fi
            done
            if [ "$compilato" == "1" ]; then    #Se ha compilato i file
                if g++ -m32 -O2 -g $cartella_progetto/*.o -o $cartella_progetto/release/linux/32bit/$current_dir -fexceptions -Wall;then
                    echo "${bold}Compilazione effettuata! File eseguibile su release/linux/32bit/"$current_dir
                    compilazione_linux_32="1"
                else
                    compilazione_linux_32="0"
                fi
                rm -rf $cartella_progetto/*.o   #Elimino tutti i file .o
            fi
        else
            compilato="1"
            for file in $cartella_progetto/*.c; do   #Per tutti i file C
                #Li compilo uno ad uno
                if ! gcc -m32 -c $file -o ${file/%cpp/o}; then   #Se non compila
                    compilato="0"
                fi
            done
            if [ "$compilato" == "1" ]; then    #Se ha compilato i file
                if gcc -m32 -O2 -g $cartella_progetto/*.o -o $cartella_progetto/release/linux/32bit/$current_dir -fexceptions -Wall;then
                    echo "${bold}Compilazione effettuata! File eseguibile su release/linux/32bit/"$current_dir
                    compilazione_linux_32="1"
                else
                    compilazione_linux_32="0"
                fi
                rm -rf $cartella_progetto/*.o   #Elimino tutti i file .o
            fi
        fi
    fi
    if [ "$distribuzione" == "1" ] || [ "$distribuzione" == "3" ]; then #Compilo per Windows solo se lo prevede il progetto
        #Compilo per Windows, per C o per C++
        #Compilo per 64 bit solo se sono su 64 bit
        if [ "$architettura" == "x86_64" ]; then
            echo "${normal}Compilo per Windows a 64 bit..."
            if [ "$tipo_progetto" == "c++" ]; then
                compilato="1"
                for file in $cartella_progetto/*.cpp; do   #Per tutti i file C++
                    #Li compilo uno ad uno
                    if ! x86_64-w64-mingw32-g++ -c $file -o ${file/%cpp/o}; then   #Se non compila
                        compilato="0"
                    fi
                done
                if [ "$compilato" == "1" ]; then    #Se ha compilato i file
                    if x86_64-w64-mingw32-g++ -g -O2 $cartella_progetto/*.o -o "$cartella_progetto/release/windows/64bit/$current_dir.exe" -fexceptions -Wall -static-libgcc -static-libstdc++;then
                        echo "${bold}Compilazione effettuata! File eseguibile su release/windows/64bit/"$current_dir".exe"
                        compilazione_windows_64="1"
                    else
                        compilazione_windows_64="0"
                    fi
                    rm -rf $cartella_progetto/*.o   #Elimino tutti i file .o
                fi
            else
                compilato="1"
                for file in $cartella_progetto/*.c; do   #Per tutti i file C
                    #Li compilo uno ad uno
                    if ! x86_64-w64-mingw32-gcc -c $file -o ${file/%cpp/o}; then   #Se non compila
                        compilato="0"
                    fi
                done
                if [ "$compilato" == "1" ]; then    #Se ha compilato i file
                    if x86_64-w64-mingw32-gcc -g -O2 $cartella_progetto/*.o -o "$cartella_progetto/release/windows/64bit/$current_dir.exe" -fexceptions -Wall -static-libgcc -static-libstdc++;then
                        echo "${bold}Compilazione effettuata! File eseguibile su release/windows/64bit/"$current_dir".exe"
                        compilazione_windows_64="1"
                    else
                        compilazione_windows_64="0"
                    fi
                    rm -rf $cartella_progetto/*.o   #Elimino tutti i file .o
                fi
            fi
        fi
        echo "${normal}Compilo per Windows a 32 bit..."
        if [ "$tipo_progetto" == "c++" ]; then
            compilato="1"
            for file in $cartella_progetto/*.cpp; do   #Per tutti i file C++
                #Li compilo uno ad uno
                if ! i686-w64-mingw32-g++ -c $file -o ${file/%cpp/o}; then   #Se non compila
                    compilato="0"
                fi
            done
            if [ "$compilato" == "1" ]; then    #Se ha compilato i file
                if i686-w64-mingw32-g++ -g -O2 $cartella_progetto/*.o -o "$cartella_progetto/release/windows/32bit/$current_dir.exe" -fexceptions -Wall -static-libgcc -static-libstdc++;then
                    echo "${bold}Compilazione effettuata! File eseguibile su release/windows/32bit/"$current_dir".exe"
                    compilazione_windows_32="1"
                else
                    compilazione_windows_32="1"
                fi
                rm -rf $cartella_progetto/*.o   #Elimino tutti i file .o
            fi
        else
            compilato="1"
            for file in $cartella_progetto/*.c; do   #Per tutti i file C
                #Li compilo uno ad uno
                if ! i686-w64-mingw32-gcc -c $file -o ${file/%cpp/o}; then   #Se non compila
                    compilato="0"
                fi
            done
            if [ "$compilato" == "1" ]; then    #Se ha compilato i file
                if i686-w64-mingw32-gcc -g -O2 $cartella_progetto/*.o -o "$cartella_progetto/release/windows/32bit/$current_dir.exe" -fexceptions -Wall -static-libgcc -static-libstdc++;then
                    echo "${bold}Compilazione effettuata! File eseguibile su release/windows/32bit/"$current_dir".exe"
                    compilazione_windows_32="1"
                else
                    compilazione_windows_32="0"
                fi
                rm -rf $cartella_progetto/*.o   #Elimino tutti i file .o
            fi
        fi
    fi
else    #Altrimenti
    #Al momento compila solo i progetti di QT Creator
    #Compilo il progetto
    cd $cartella_progetto
    make clean
    echo "${normal}Compilo per Linux..."
    if qmake -qt=qt5 && make; then   #Se compila il progetto
        if mv $nome_progetto release/linux/64bit/$nome_progetto; then
            echo "${bold}Progetto compilato con successo. File eseguibile su $cartella_progetto/release/linux/64bit/$nome_progetto"
            compilazione_linux_64="1"
            compilazione_linux_32="0"
            compilazione_windows_64="0"
            compilazione_windows_32="0"
        else
            compilazione_linux_64="0"
            compilazione_linux_32="0"
            compilazione_windows_64="0"
            compilazione_windows_32="0"
            tput setaf 1; echo "Impossibile compilare il progetto!"
        fi
    else
        tput setaf 1; echo "Impossibile compilare il progetto!"
        
    fi
    make clean
fi
if [ "$compilazione_linux_64" == "1" ] && [ "$compilazione_linux_32" == "1" ] && [ "$compilazione_windows_64" == "1" ] && [ "$compilazione_windows_32" == "1" ]; then
    comp_fallite=0
else
    comp_fallite=$(($comp_fallite + 1))
fi
echo $comp_fallite > $cartella_progetto/.comperror    #Aggiorno il numero di compilazioni fallite
if ! test $comp_fallite -lt 2; then
    echo "${bold}E' la $comp_fallite° volta di fila che la compilazione non ha successo, hai bisogno di una mano? AHAHAHAHAHAHAH"
fi
echo "${normal}"
#Se ha scelto di eseguire il programma
if [ "$eseguire" == "1" ]; then
    echo "----------------------------------"
    echo "Esecuzione programma in corso..."
    echo ----------------------------------
    if [ "$distribuzione" == "3" ]; then    #Se e' un progetto solo per Windows
        #Se sono su 64 bit
        if [ "$architettura" == "x86_64" ]; then
            #Se la compilazione ha avuto successo
            if [ "$compilazione_windows_64" == "1" ]; then
                if [ "$tipo_grafica" == "console" ]; then
                    clear
                fi
                #Se il programma non si puo' eseguire
                if ! xterm -hold -e wine $cartella_progetto/release/windows/64bit/*.exe;then
                    echo -------------------------------
                    tput setaf 1; echo Impossibile aprire il programma
                    echo -------------------------------
                fi
            else    #Altrimenti
                tput setaf 1; echo "Non posso eseguire il programma perche' la compilazione non ha avuto successo!"
            fi
        else    #Altrimenti
            #Se la compilazione ha avuto successo
            if [ "$compilazione_windows_32" == "1" ]; then
                if [ "$tipo_grafica" == "console" ]; then
                    clear
                fi
                #Se il programma si puo' eseguire
                if ! xterm -hold -e wine $cartella_progetto/release/windows/32bit/*.exe;then
                    echo -------------------------------
                    tput setaf 1; echo Impossibile aprire il programma
                    echo -------------------------------
                fi
            else    #Altrimenti
                tput setaf 1; echo "Non posso eseguire il programma perche' la compilazione non ha avuto successo!"
            fi
        fi
    else    #Altrimenti
        #Se sono su 64 bit
        if [ "$architettura" == "x86_64" ]; then
            #Se la compilazione ha avuto successo
            if [ "$compilazione_linux_64" == "1" ]; then
                if [ "$tipo_grafica" == "console" ]; then
                    clear
                fi
                #Se il programma non si puo' eseguire
                if ! xterm -hold -e $cartella_progetto/release/linux/64bit/./*;then
                    echo -------------------------------
                    tput setaf 1; echo Impossibile aprire il programma
                    echo -------------------------------
                fi
            else    #Altrimenti
                tput setaf 1; echo "Non posso eseguire il programma perche' la compilazione non ha avuto successo!"
            fi
        else    #Altrimenti
            #Se la compilazione ha avuto successo
            if [ "$compilazione_linux_32" == "1" ]; then
                if [ "$tipo_grafica" == "console" ]; then
                    clear
                fi
                #Se il programma si puo' eseguire
                if ! xterm -hold -e $cartella_progetto/release/linux/32bit/./*;then
                    echo -------------------------------
                    tput setaf 1; echo Impossibile aprire il programma
                    echo -------------------------------
                fi
            else    #Altrimenti
                tput setaf 1; echo "Non posso eseguire il programma perche' la compilazione non ha avuto successo!"
            fi
        fi
    fi
fi
